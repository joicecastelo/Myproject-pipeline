# Criar repositorio

resource "aws_ecr_repository" "my_second_repo" {
  name                 = "my-second-repo" # Nome do meu repositório
  image_tag_mutability = "IMMUTABLE"

  encryption_configuration {
  encryption_type = "KMS"
  
 }

 image_scanning_configuration {
   scan_on_push = true
 } 
}
