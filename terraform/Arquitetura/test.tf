
resource "random_id" "random_id_prefix" {
  byte_length = 2
}



locals {
  testing_availability_zones = ["${var.region}a", "${var.region}b"] 
}



module "Network" {
  source               = "./modules/Network"
  region           = var.region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  
  /*
  public_subnet_a      = var.public_cidr_a
  public_subnet_b      = var.public_cidr_b
  private_subnet_a     = var.private_cidr_a
  private_subnet_b  = var.private_cidr_b
  */
  availability_zones = local.testing_availability_zones
  
}


module "Computing-ECS" {

  source               = "./modules/Computing-ECS"
  depends_on           = [module.Network]
  docker_image_name    = var.docker_image_name
  environment          = var.environment
  vpc_id               = module.Network.vpc_id

/*
  public_subnet_a      = module.Network.public_cidr_a
  public_subnet_b  =  module.Network.public_cidr_b
  private_subnet_a =  module.Network.private_cidr_a
  private_subnet_b =  module.Network.private_cidr_b
  availability_zones= local.testing_availability_zones
  */

  
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