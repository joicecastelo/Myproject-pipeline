

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
variable "availability_zones" {
  type        = string
  description = "AZ in which all the resources will be deployed"
}







