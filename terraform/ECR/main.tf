

terraform {
  required_version = ">= 1.0.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.62.0"
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
}



# Criar repositorio

resource "aws_ecr_repository" "my_second_repo" {
  name                 = "my-second-repo" # Nome do meu repositório


   image_tag_mutability            = "IMMUTABLE"             # Added after checkov analysis
   image_scanning_configuration {                            # Added after checkov analysis
    scan_on_push = true
  } 
  encryption_configuration {                                # Added after checkov analysis
    encryption_type                 = "KMS"                   
  }
  force_delete                    = true

}




#  Outputs           


output "aws_ecr_registry_id" {

value = aws_ecr_repository.my_second_repo.registry_id

}



output "aws_ecr_repository_url" {

 value = aws_ecr_repository.my_second_repo.repository_url

}





