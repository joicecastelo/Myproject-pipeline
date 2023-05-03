provider "aws" {
    region = "us-east-1"
  
}


# Criar repositorio

resource "aws_ecr_repository" "my_second_repo" {
  name                 = "my-second-repo" # Nome do meu repositório
  
}
  /*
  
  encryption_configuration {
  encryption_type = "KMS"
  
 }

 image_scanning_configuration {
   scan_on_push = true
 } 
}

*/