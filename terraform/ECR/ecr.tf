provider "aws" {
    region = "us-east-1"
  
}


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