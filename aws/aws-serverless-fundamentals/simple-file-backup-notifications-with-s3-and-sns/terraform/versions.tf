# Terraform version and provider requirements
# This file define sth eminimu version required for Terraform and AWS provider

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }

  # Optional: Configure backend for state management
  # Uncomment and configure as needed for your enviornment
  # backend "s3" {
  #  bucket = "your-terraform-state-bucket"
  #  key = "aws-backup-notifications-s3-sns/terraform.tfstate"
  #  region = "eu-central-1"
  #  encrypt = true
  #  use_lockfile = true
  #  }
}

# AWS Provider configuration
# Uses default AWS CLI profile or environment variables for authentication
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Simple File Backup Notifications"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Recipe      = "simple-file-backup-notifications-s3-sns"
    }
  }
}
