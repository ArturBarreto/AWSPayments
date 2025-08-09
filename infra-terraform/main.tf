terraform {
  backend "s3" {
    bucket         = "tf-state-982534393012-eu-west-3"
    key            = "awspayments/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "tf-locks"
    encrypt        = true
  }

  required_version = ">= 1.6.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.50" }
    archive = { source = "hashicorp/archive", version = "~> 2.5" }
  }
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

locals {
  project = "payments"
  env     = "dev"
  tags = {
    Project = local.project
    Env     = local.env
    Owner   = "Artur"
  }
}
