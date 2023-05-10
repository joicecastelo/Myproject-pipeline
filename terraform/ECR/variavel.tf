variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment Environment"
  default     = "testing"
}