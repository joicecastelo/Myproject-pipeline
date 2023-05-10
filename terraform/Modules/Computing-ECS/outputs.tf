

# Criar Load balancer

resource "aws_alb" "alb" {
  name = "dummy-api-ecs-alb"
  
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_security.id]
  subnets            = [aws_subnet.public_east_a.id, aws_subnet.public_east_b.id]

}




output "alb_address" {
  
  value = aws_alb.alb.dns_name
}
