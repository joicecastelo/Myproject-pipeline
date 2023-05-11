
/*

#-------Create VPC 

resource "aws_vpc" "project_ecs" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

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
# Associacão do route publico a
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_east_b.id
  route_table_id = aws_route_table.public_b.id
}



# Route table privado b 
resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.project_ecs.id
  tags = {
    Name = " route table privada 2"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id

  }
}

# Associação route table private a
resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_east_b.id
  route_table_id = aws_route_table.private_b.id
}



*/