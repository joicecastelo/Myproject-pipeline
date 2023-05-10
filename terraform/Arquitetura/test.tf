
resource "random_id" "random_id_prefix" {
  byte_length = 2
}

locals {
  testing_availability_zones = ["${var.aws_region}a", "${var.aws_region}b"] #, "${var.aws_region}b", "${var.aws_region}c"]
}

module "Network" {
  source               = "./modules/Network"
  aws_region           = var.aws_region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_cidr_a  = var.public_cidr_a
  public_cidr_b  = var.public_cidr_b
  private_cidr_a  = var.private_cidr_a
  private_cidr_b  = var.private_cidr_b
  
  availability_zones   = local.testing_availability_zones

}

module "Computing-ECS" {

  source               = "./modules/Computing-ECS"
  depends_on              = [module.Network]
  docker_image_name       = var.docker_image_name
  environment          = var.environment
  vpc_ip           =   module.Network.vpc_id

  public_cidr_a  = module.Network.public_cidr_a
  public_cidr_b  =  module.Network.public_cidr_b
  private_cidr_a =  module.Network.private_cidr_a
  private_cidr_b =  module.Network.private_cidr_b
  
  availability_zones   = local.testing_availability_zones

}




output "alb_domain" {
  value = module.Computing-ECS.alb_address
}

output "alb_address" {
  value = "http://${module.Computing-ECS.alb_address}"
}

output "aws_ecs_cluster_id" {
  value = module.Computing-ECS.aws_ecs_cluster_id
}

output "aws_ecs_service_name" {
  value = module.Computing-ECS.aws_ecs_service_name
}

output "aws_ecs_service_id" {
  value = module.Computing-ECS.aws_ecs_service_id
}