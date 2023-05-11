variable "docker_image_name" {}

variable "environment" {
  description = "Deployment Environment"
}


variable "vpc_id" {
  description = "ID of the vpc"
}

variable "vpc_cidr" {
  description = "CIDR range for created VPC"
  type        = string
  default     = "10.0.0.0/16"
}

