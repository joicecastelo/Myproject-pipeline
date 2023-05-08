


variable "region" {
  description = "region to use for AWS resources"
  type        = string
  default     = "us-east-1"
}

variable "region_a" {
  description = "The region the environment is going to be installed into"
  type        = string
  default     = "us-east-1a"
}
variable "region_b" {
  description = "The region the environment is going to be installed into"
  type        = string
  default     = "us-east-1b"
}


variable "health_check_path" {
  default = "/"
}


variable "cidr" {
  description = "CIDR range for created VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_cidr_a" {
  description = "CIDR range for created VPC"
  type        = string
  default     = "10.0.11.0/24"
}

variable "private_cidr_b" {
  description = "CIDR range for created VPC"
  type        = string
  default     = "10.0.10.0/24"
}


variable "public_cidr_a" {
  description = "CIDR range for created VPC"
  type        = string
  default     = "10.0.1.0/27"
}

variable "public_cidr_b" {
  description = "CIDR range for created VPC"
  type        = string
  default     = "10.0.1.32/27"
}


variable "environment" {
  description = "Deployment Environment"
  default     = "testing"
}


variable "ecs_task_execution_role" {
  default     = "myECcsTaskExcecutionRole"
  description = "ECS Task Execution Role name"
}


variable "docker_image_name" {}




# Criar repositorio

resource "aws_ecr_repository" "my_second_repo" {
  name                 = "my-second-repo" # Nome do meu repositório
  
}


################################

#           Outputs            #

################################

output "aws_ecr_registry_id" {

value = aws_ecr_repository.my_second_repo.registry_id

}




output "aws_ecr_repository_url" {

 value = aws_ecr_repository.my_second_repo.repository_url

}


