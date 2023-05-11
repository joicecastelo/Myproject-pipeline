output "alb_address" {
  value = aws_alb.alb.dns_name
}

output "aws_ecs_cluster_id" {
  value = aws_ecs_cluster.my_cluster.id
}

output "aws_ecs_service_name" {
  value = aws_ecs_service.dummy_api_service.name
}

output "aws_ecs_service_id" {
  value = aws_ecs_service.dummy_api_service.id
}

