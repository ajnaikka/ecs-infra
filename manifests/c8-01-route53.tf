resource "aws_route53_zone" "ecs_zone" {
  name = var.project_url
}

output "name_servers" {
  value = aws_route53_zone.ecs_zone.name_servers
}

resource "aws_route53_record" "ecs_record" {
  zone_id = aws_route53_zone.ecs_zone.zone_id
  name    = var.project_url
  type    = "A"

  alias {
    name                   = aws_lb.ecs_lb.dns_name
    zone_id                = aws_lb.ecs_lb.zone_id
    evaluate_target_health = false
  }
}
