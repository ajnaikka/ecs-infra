# Input Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "ap-south-1"
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "prod"
}
# Business Division
variable "business_unit" {
  description = "Business Division in the organization this Infrastructure belongs"
  type        = string
  default     = "odoo"
}

variable "manager" {
  description = "Managed by"
  type        = string
  default     = "Terraform"
}