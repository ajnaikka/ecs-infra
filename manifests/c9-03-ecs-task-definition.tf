resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "ecs_task_definition"
  network_mode             = "awsvpc" # awsvpc is required for Fargate
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024" # Change according to your requirements
  memory                   = "2048" # Change according to your requirements
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  volume {
    name = "efs-ecs-volume"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.ecs_efs.id
      root_directory = "/" # Root directory to mount. Adjust if necessary
    }
  }
  volume {
    name = "nginx-config-volume"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.ecs_efs.id
      root_directory = "/nginxconf"
    }
  }


  container_definitions = jsonencode([
    {
      name      = "ecs_odoo_container",
      image     = "${aws_ecr_repository.ecs_ecr_repository.repository_url}:latest",
      essential = true,
      portMappings = [
        {
          containerPort = 8069,
          hostPort      = 8069,
          protocol      = "tcp"
        },
        {
          containerPort = 8072,
          hostPort      = 8072,
          protocol      = "tcp"
        }
      ],
      mountPoints = [
        {
          sourceVolume  = "efs-ecs-volume",
          containerPath = "/var/lib/odoo",
          readOnly      = false
        }
      ],
      environment = [
        {
          name  = "HOST",
          value = "${module.rds-aurora.cluster_endpoint}"
        },
        {
          name  = "USER",
          value = "odoo"
        }
      ],
      secrets = [
        {
          name      = "PASSWORD",
          valueFrom = "${aws_secretsmanager_secret.odoo_db_password.arn}"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/ecs_odoo",
          awslogs-region        = "ap-south-1",
          awslogs-stream-prefix = "ecs"
        }
      }
    },
    {
      name      = "ecs_nginx_container",
      image     = "${aws_ecr_repository.ecs_ecr_nginx_repository.repository_url}:latest"
      essential = true,
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80,
          protocol      = "tcp"
        },
        {
          containerPort = 443,
          hostPort      = 443,
          protocol      = "tcp"
        }
      ],
      mountPoints = [
        {
          sourceVolume  = "nginx-config-volume",
          containerPath = "/etc/nginx/conf.d",
          readOnly      = true
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/nginx",
          awslogs-region        = "ap-south-1",
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

}

resource "aws_cloudwatch_log_group" "ecs_odoo_container" {
  name              = "/ecs/ecs_odoo"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "ecs_nginx_container" {
  name              = "/ecs/nginx"
  retention_in_days = 7
}
