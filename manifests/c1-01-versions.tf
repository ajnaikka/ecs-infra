# This file is used to define the versions of the providers and terraform itself.
terraform {
  required_version = "~> 1.5.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.10.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5"
    }
  }
#This is used to store the terraform state file in S3 bucket
  backend "s3" {
    bucket = "loyal-terraform-state"
    key    = "ecs/terraform.tfstate"
    region = "ap-south-1"
    # This is used to lock the state file when someone is working on it
    # dynamodb_table = "ecs-terraform-lock"
  }
}

provider "aws" {
  region = var.aws_region
}

