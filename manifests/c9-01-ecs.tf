
resource "aws_ecs_cluster" "ecs_odoo_cluster" {
  name = "ecs_odoo_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_odoo_cluster_capacity_providers" {
  cluster_name = aws_ecs_cluster.ecs_odoo_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}



