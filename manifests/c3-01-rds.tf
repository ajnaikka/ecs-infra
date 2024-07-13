# Terraform module for creating an RDS aurora postgresql database

data "aws_rds_engine_version" "postgresql" {
  engine  = "aurora-postgresql"
  version = "15.3"
}



module "rds-aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "8.3.1"

  name                        = "${local.name}-postgresqlv2"
  engine                      = data.aws_rds_engine_version.postgresql.engine
  engine_mode                 = "provisioned"
  engine_version              = data.aws_rds_engine_version.postgresql.version
  storage_encrypted           = true
  master_username             = "postgres"
  manage_master_user_password = true
  create_security_group       = false


  vpc_id               = aws_vpc.ecs_vpc.id
  db_subnet_group_name = aws_db_subnet_group.ecs_db_subnet_group.name

  vpc_security_group_ids = [aws_security_group.ecs_rds_sg.id]

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = true

  serverlessv2_scaling_configuration = {
    min_capacity = 1
    max_capacity = 10
  }

  instance_class = "db.serverless"
  instances = {
    one = {}
    # two = {}
  }

  tags = local.common_tags
}


output "rds_secret_arn" {
  value = module.rds-aurora.cluster_master_user_secret
}


