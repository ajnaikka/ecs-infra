# Request a certificate from ACM
resource "aws_acm_certificate" "cert" {
  domain_name       = var.project_url
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}



# Create a validation record to verify domain ownership
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.ecs_zone.zone_id
}

# Confirm that the certificate has been validated
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# Add an HTTPS listener to the ALB
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate_validation.cert_validation.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_nginx_tg.arn
  }
}

# Redirect HTTP to HTTPS
resource "aws_lb_listener_rule" "redirect_http_to_https" {
  listener_arn = aws_lb_listener.ecs_listener.arn
  priority     = 1

  action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = [var.project_url]
    }
  }
}


output "cert_arn" {
  value = aws_acm_certificate_validation.cert_validation.certificate_arn
}


