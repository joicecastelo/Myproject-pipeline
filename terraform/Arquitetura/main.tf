
terraform {
  required_version = ">= 1.0.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65.0"
    }
  }


backend "s3" {
    bucket = "mybucketjoice"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }


}



provider "aws" {
  region = "us-east-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
 
}


/*

provider "aws" {
  region = "us-east-1"
}
*/



resource "aws_cloudwatch_log_group" "base_api" {
  name = "base-api"

  
}

resource "aws_cloudwatch_log_stream" "base_api" {
  name           = "base-api"
  log_group_name = aws_cloudwatch_log_group.base_api.name
}



#Criar cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster" # Nome do cluster
}

/*
setting {
   name  = "containerInsights"
   value = "enabled"
 }
}

*/


resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}


/*

resource "aws_iam_role" "ecs_task_role" {
  name = "role-name"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

*/

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}


# Definir as tarefas
resource "aws_ecs_task_definition" "dummy_api_task" {
  family                   = "service"   # Naming our first task
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 2048        # Specifying the memory our container requires
  cpu                      = 512         # Specifying the CPU our container requires
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  #task_role_arn = aws_iam_role.ecs_task_role.arn

  container_definitions = <<DEFINITION
  [
    {
      "name": "dummy_task",
      "image": "${var.docker_image_name}",
      "essential": true,
      "memory": 1024,
      "cpu": 512,

      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
          

        }
      ],
      

      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "base-api",
          "awslogs-stream-prefix": "base-api",
          "awslogs-region": "us-east-1"
        }
      },
      "environment": [
        {"name": "APP_ENV", "value": "test"}
     ] 
    }
  ]
  DEFINITION
}




# Criar Load balancer

resource "aws_alb" "alb" {
  name = "dummy-api-ecs-alb"
  
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_security.id]
  subnets            = [aws_subnet.public_east_a.id, aws_subnet.public_east_b.id]


  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}


# Criar target grupo

resource "aws_lb_target_group" "mydummy_api_tg" {
  name        = "mydummy-api-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.project_ecs.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    matcher             = "200"
    path                = var.health_check_path
    interval            = 30

  }

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}







#Create and ALB Listener that points to the Target Group just created

resource "aws_lb_listener" "dummy_api_listener" {
  load_balancer_arn = aws_alb.alb.arn

  port     = "80"
  protocol = "HTTP"
  default_action {

    type             = "forward"
    target_group_arn = aws_lb_target_group.mydummy_api_tg.arn
  }


  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
  }

}





resource "aws_ecs_service" "dummy_api_service" {

  name            = "dummy_api"    
  #depends_on =[aws_ecs_task_definition.dummy_api_task]                           # Naming our first service
  cluster         = aws_ecs_cluster.my_cluster.id             # Referencing our created Cluster
  task_definition = aws_ecs_task_definition.dummy_api_task.id # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  
  desired_count = 4 # Numero de container que quero correr são  4}
  platform_version = "LATEST"



  load_balancer {
    target_group_arn = aws_lb_target_group.mydummy_api_tg.arn
    container_name   = "base_api"
    container_port   = 80

  }

  lifecycle {
    ignore_changes = [task_definition]
  }




  #depends_on = [aws_lb_listener.dummy_api_listener,aws_iam_role_policy_attachment.ecsTaskExecutionRole_policy]

  network_configuration {

    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_security.id]
    subnets          = [aws_subnet.private_east_a.id, aws_subnet.private_east_b.id]

  }
}




