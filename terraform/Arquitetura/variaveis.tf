
variable "docker_image_name" {}



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


variable "vpc_cidr" {
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


#output 


output "alb_address" {
  value = "http://${aws_alb.alb.dns_name}"
}


output "aws_ecs_cluster_id" {
  value = aws_ecs_cluster.my_cluster.id
}

output "aws_ecs_service_name" {
  value = aws_ecs_service.dummy_api_service.name
}

output "aws_ecs_service_id" {
  value = aws_ecs_service.dummy_api_service.id
}
