# AWS CLI Setup and First Commands - Terraform Infrastructure
# This Terraform configuration creates the necessary infrastructure for learning AWS CLI
# including an S3 bucket with proper security configurations and IAM resources

# Configure the AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
  required_version = ">= 1.5"
}

# Data soruce to get current AWS caller identity
data "aws_caller_identity" "current" {}

# Data source to get current AWS region
data "aws_region" "current" {}

# Generate random suffix for unique resource naming
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Create S3 bucket for CLI tutotiral with unique nameing
resource "aws_s3_bucket" "cli_tutorial_bucket" {
  bucket = "${var.bucket_prefix}-${random_id.bucket_suffix.hex}"

  tags = {
    Name = "AWS CLI Tutorial Bucket"
    Purpose = "AWS CLI Leaning and Practice"
    Environment = var.environment
    Recipe = "aws-cli-setup-first-commands"
    ManagedBy = "Terraform"
  }
}

# Configure S3 bucket versioning for best practices
resource "aws_s3_bucket_versioning" "cli_tutorial_bucket_versioning" {
  bucket = aws_s3_bucket.cli_tutorial_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure server-side encryption for S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "cli_tutorial_bucket_encryption" {
  bucket = aws_s3_bucket.cli_tutorial_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block public access to S3 bucket for security
resource "aws_s3_bucket_public_access_block" "cli_tutorial_bucket_pab" {
  bucket = aws_s3_bucket.cli_tutorial_bucket.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# Configure S3 bucket lifecycle to manage costs and demostrate best practice
resource "aws_s3_bucket_lifecycle_configuration" "cli_tutorial_bucket_lifecycle" {
  bucket = aws_s3_bucket.cli_tutorial_bucket.id 

  rule {
    id = "tutorial_cleanup"
    status = "Enabled"

    # Delete objects after 7 days to avoid costs for tutorial
    expiration {
      days = 7
    }
    
    # Delete non-current versions after 1 day
    noncurrent_version_expiration {
      noncurrent_days = 1
    }

    # Clean up incomplete multipart uploads after 1 day
    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }
  }
}

# Create IAM policy for S4 access (for CLI users)
resource "aws_iam_policy" "cli_tutorial_s3_policy" {
  name = "${var.iam_policy_prefix}-s3-access"
  description = "Policy for AWS CLI tutorial S3 access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetBucketEncryption",
          "s3:GetBucketVersioning"
        ]
        Resource = aws_s3_bucket.cli_tutorial_bucket.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObjectVerion",
          "s3:GetObjectMetadata"
        ]
        Resource = "${aws_s3_bucket.cli_tutorial_bucket.arn}/*"
      }
    ]
  })

  tags = {
    Name = "AWS CLI Tutorial S3 Policy"
    Purpose = "AWS CLI Learning and Practice"
    Recipe = "aws-cli-setup-first-commands"
    ManagedBy = "Terraform"
  }
}
