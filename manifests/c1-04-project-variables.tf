variable "repository_name" {
  description = "Name of the repository"
  type        = string
  default     = "ecs-odoo"
}

variable "repository_description" {
  description = "Description of the repository"
  type        = string
  default     = "ecs Odoo Custom addons repository"
}

variable "project_url" {
  description = "URL of the project"
  type        = string
  default     = "ecsdemo2.loyalerp.in"
}

variable "bastion_key_name" {
  description = "Name of the key pair"
  type        = string
  default     = "fwf"
}
