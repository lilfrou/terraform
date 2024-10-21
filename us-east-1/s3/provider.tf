terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket  = "lilfrou-terraform-state"
    key     = "terraform/us-east-1/s3.tfstate" # path to the state file in the bucket
    region  = "us-east-1"                      # AWS region of the bucket
    encrypt = false                            # encrypt the state file
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      ManagedBy = "Terraform"
    }
  }
}

data "aws_caller_identity" "current" {}