resource "aws_codecommit_repository" "ecs_codecommit_repo" {
  repository_name = var.repository_name
  description     = var.repository_description

  tags = {
    Name = "ecs-codecommit-repo"
  }
}

output "repository_clone_url_http" {
  value = aws_codecommit_repository.ecs_codecommit_repo.clone_url_http
}

output "repository_clone_url_ssh" {
  value = aws_codecommit_repository.ecs_codecommit_repo.clone_url_ssh
}

output "repository_arn" {
  value = aws_codecommit_repository.ecs_codecommit_repo.arn
}

output "repository_id" {
  value = aws_codecommit_repository.ecs_codecommit_repo.id
}

output "repository_name" {
  value = aws_codecommit_repository.ecs_codecommit_repo.repository_name
}

output "repository_default_branch" {
  value = aws_codecommit_repository.ecs_codecommit_repo.default_branch
}

