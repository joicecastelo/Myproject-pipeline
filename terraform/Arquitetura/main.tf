
terraform {
  required_version = ">= 1.0.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65.0"
    }
  }

}

provider "aws" {
  region = "us-east-1"
}





#Criar cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster" # Nome do cluster

setting {
   name  = "containerInsights"
   value = "enabled"
 }
}



resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}


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


data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    #sid     = ""
    #effect  = "Allow"
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
  task_role_arn = aws_iam_role.ecs_task_role.arn

  container_definitions = <<DEFINITION
  [
    {
      "name": "dummy_api",
      "image": "${var.docker_image_name}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "memory": 1024,
      "cpu": 512
    }
  ]
  DEFINITION
}



resource "aws_ecs_service" "dummy_api_service" {

  name            = "dummy_api"    
  depends_on =[aws_ecs_task_definition.dummy_api_task]                           # Naming our first service
  cluster         = aws_ecs_cluster.my_cluster.id             # Referencing our created Cluster
  task_definition = aws_ecs_task_definition.dummy_api_task.id # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  
  desired_count = 4 # Numero de container que quero correr são  4}




  load_balancer {
    target_group_arn = aws_lb_target_group.mydummy_api_tg.arn
    container_name   = "dummy_api"
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


