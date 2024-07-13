resource "aws_ecs_service" "service" {
  name                              = "ecs-odoo-service"
  cluster                           = aws_ecs_cluster.ecs_odoo_cluster.id
  task_definition                   = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count                     = 2
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = false
    subnets          = [aws_subnet.ecs_private_subnet_1.id, aws_subnet.ecs_private_subnet_2.id]
    security_groups  = [aws_security_group.ecs_alb_sg.id]
  }

  // Pointing to Nginx for all traffic (both HTTP and WebSocket)
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_nginx_tg.arn
    container_name   = "ecs_nginx_container" // Name of the Nginx container in your task definition
    container_port   = 80                     // Nginx will listen on port 80
  }

  depends_on = [module.rds-aurora]
}
