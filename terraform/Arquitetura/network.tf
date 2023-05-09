
#-------Create VPC 

resource "aws_vpc" "project_ecs" {
  cidr_block = var.cidr

  tags = {
    Name = "My VPC"
  }
}

#--------Create Private subnets for ECS

resource "aws_subnet" "private_east_a" {
  vpc_id            = aws_vpc.project_ecs.id
  cidr_block        = var.private_cidr_a
  availability_zone = var.region_a

  tags = {
    Name = "Private East A"
  }
}

resource "aws_subnet" "private_east_b" {
  vpc_id            = aws_vpc.project_ecs.id
  cidr_block        = var.private_cidr_b
  availability_zone = var.region_b


  tags = {
    Name = "Private East B"
  }
}


#--------Create Public subnets 

resource "aws_subnet" "public_east_a" {
  vpc_id            = aws_vpc.project_ecs.id
  cidr_block        = var.public_cidr_a
  availability_zone = var.region_a

  tags = {
    Name = "Public East A"
  }
}

resource "aws_subnet" "public_east_b" {
  vpc_id            = aws_vpc.project_ecs.id
  cidr_block        = var.public_cidr_b
  availability_zone = var.region_b


  tags = {
    Name = "Public East B"
  }
}


# Criar elastic ip

resource "aws_eip" "nat" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]

}

#Criando internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.project_ecs.id

  tags = {
    Name = "Internet gw"
  }
}



#Criando NAT gateway

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_east_a.id

  tags = {
    Name = "gw NAT"
  }

}



#Criando route table

# Route table publica a
resource "aws_route_table" "public_a" {
  vpc_id = aws_vpc.project_ecs.id
  tags = {
    Name = " route table public 1"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  }
}

# Associacão do route publico a
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_east_a.id
  route_table_id = aws_route_table.public_a.id
}


# Route table privado a 
resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.project_ecs.id
  tags = {
    Name = " route table privada 1"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id

  }
}

# Associação route table private a
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_east_a.id
  route_table_id = aws_route_table.private_a.id
}


#Route table publico b 
resource "aws_route_table" "public_b" {
  vpc_id = aws_vpc.project_ecs.id
  tags = {
    Name = " route table public 2"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  }
}

# Criar Load balancer

resource "aws_alb" "alb" {
  name = "dummy-api-ecs-alb"
  
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_security.id]
  subnets            = [aws_subnet.public_east_a.id, aws_subnet.public_east_b.id]

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





