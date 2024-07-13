resource "aws_lb" "ecs_lb" {
  name               = "ecs-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.ecs_public_subnet_1.id, aws_subnet.ecs_public_subnet_2.id]

  tags = local.common_tags
}



output "alb_name" {
  value = aws_lb.ecs_lb.name
}

output "alb_arn" {
  value = aws_lb.ecs_lb.arn
}

output "alb_dns_name" {
  value = aws_lb.ecs_lb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.ecs_lb.zone_id
}

