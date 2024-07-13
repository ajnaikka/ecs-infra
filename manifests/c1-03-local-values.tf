
# Define Local Values in Terraform
locals {
  owners      = var.business_unit
  environment = var.environment
  name        = "${var.business_unit}-${var.environment}"
  manager     = var.manager
  common_tags = {
    owners      = local.owners
    environment = local.environment
    manager     = local.manager
  }
} 