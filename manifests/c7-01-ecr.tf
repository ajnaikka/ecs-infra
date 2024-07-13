resource "aws_ecr_repository" "ecs_ecr_repository" {
    name = "ecs_odoo"
    image_tag_mutability = "MUTABLE"
    image_scanning_configuration {
        scan_on_push = true
    }
    tags = local.common_tags
  
}

resource "aws_ecr_repository" "ecs_ecr_nginx_repository" {
    name = "ecs_nginx"
    image_tag_mutability = "MUTABLE"
    image_scanning_configuration {
        scan_on_push = true
    }
    tags = local.common_tags
  
}


output "ecr_arn" {
    value = aws_ecr_repository.ecs_ecr_repository.arn
}

output "ecr_name" {
    value = aws_ecr_repository.ecs_ecr_repository.name
}
  
output "ecr_registry_id" {
    value = aws_ecr_repository.ecs_ecr_repository.registry_id
}

output "ecr_repository_url" {
    value = aws_ecr_repository.ecs_ecr_repository.repository_url
}

output "ecr_repository_url_with_tag" {
    value = aws_ecr_repository.ecs_ecr_repository.repository_url
}

output "ecr_repository_url_with_tag_and_digest" {
    value = aws_ecr_repository.ecs_ecr_repository.repository_url
}


output "ecr_nginx_arn" {
    value = aws_ecr_repository.ecs_ecr_nginx_repository.arn
}
  
output "ecr_nginx_name" {
    value = aws_ecr_repository.ecs_ecr_nginx_repository.name
}

output "ecr_nginx_registry_id" {
    value = aws_ecr_repository.ecs_ecr_nginx_repository.registry_id
}

output "ecr_nginx_repository_url" {
    value = aws_ecr_repository.ecs_ecr_nginx_repository.repository_url
}

output "ecr_nginx_repository_url_with_tag" {
    value = aws_ecr_repository.ecs_ecr_nginx_repository.repository_url
}

output "ecr_nginx_repository_url_with_tag_and_digest" {
    value = aws_ecr_repository.ecs_ecr_nginx_repository.repository_url
}



