
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

