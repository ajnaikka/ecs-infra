
# Define a Target Group for Nginx
resource "aws_lb_target_group" "ecs_nginx_tg" {
  name        = "ecs-nginx-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ecs_vpc.id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 60
    path                = "/web/login" # This can be adjusted based on the health check endpoint for Nginx
    port                = 80
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 5
    protocol            = "HTTP"
    matcher             = "200-310"
  }
}


# Create ALB HTTP listener
resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ecs_nginx_tg.arn
    type             = "forward"
  }
}

# Associate Target Group with ALB Listener for Odoo
resource "aws_lb_listener_rule" "ecs_listener_rule" {
  listener_arn = aws_lb_listener.ecs_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_nginx_tg.arn
  }

  condition {
    host_header {
      values = [var.project_url]
    }
  }
}
