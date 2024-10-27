terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket  = "lilfrou-terraform-state"
    key     = "terraform/us-east-1/eks.tfstate" # path to the state file in the bucket
    region  = "us-east-1"                       # AWS region of the bucket
    encrypt = true                              # encrypt the state file
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

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "lilfrou-terraform-state"
    key    = "terraform/us-east-1/vpc.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "kms" {
  backend = "s3"

  config = {
    bucket = "lilfrou-terraform-state"
    key    = "terraform/us-east-1/kms.tfstate"
    region = "us-east-1"
  }
}

data "aws_caller_identity" "current" {}
