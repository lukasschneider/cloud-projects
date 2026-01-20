# Main Terraform configuration for Simple File Backup Notifications
# This creates an S3 bucket with SNS notifications for backup monitoring

# Get current AWS account ID and caller identity
data "aws_caller_identity" "current" {}

# Get current AWS region
data "aws_region" "current" {}

# Generate a random suffix for unique resource naming
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

# Merge default and custom tags
locals {
  common_tags = merge(
    {
      Project     = "Simple File Backup Notifications"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Recipe      = "simple-file-backup-notifications-s3-sns"
    },
    var.custom_tags,
  )

  # Generate unique resource names
  bucket_name = "${var.s3_bucket_prefix}-${random_string.suffix.result}"
  sns_topic_name = "${var.sns_topic_name}-${random_string.suffix.result}"
}

# SNS Topic for backup notifications
# This topic receives S3 events and distributes them to email subscribers
resource "aws_sns_topic" "backup_notifications" {
  delivery_policy = jsonencode({
    "http" : {
      "defaultHealthyRetryPolicy" : {
        "minDelayTarget" : 20,  # Minimum delay of 20 seconds
        "maxDelayTarget" : 20,  # Maximum delay of 20 seconds
        "numRetries" : 3,       # Retry up to 3 times
        "numMaxDelayRetries" : 0, # No maximum delay retries
        "numMinDelayRetries" : 0, # No minimum delay retries
        "numNoDelayRetries" : 0, # No immediate retries
        "backoffFunction" : "linear" # Linear backoff strategy
      },
      "disableSubscriptionOverrides" : false, # Allow subscription overrides
    }
  })

  tags = local.common_tags
}

# SNS Topic Policy to allow S3 to publish messages
# This policy grants S3 the necessary permissions to send notifications 
resource "aws_sns_topic_policy" "backup_notifications_policy" {
  arn = aws_sns_topic.backup_notifications.arn

  policy = jsonencode({
    "Version" : "2012-10-17",
    Statement : [
      {
        Sid = "AllowS3Publish",
        Effect = "Allow",
        Principal = {
          Serivice = "s3.amazonaws.com"
        },
        Action = "SNS:Publish",
        Resource = aws_sns_topic.backup_notifications.arn,
        Condition = {
          StringEquals = {
            "aws:SourceAccount" : data.aws_caller_identity.current.account_id
          }
          StringLike = {
            "aws:SourceArn" : "arn:aws:s3:::${local.bucket_name}"
          }
        }
      }
    ]
  })
}

# Email subscription to SNS topic
# Creates email subscriptions for each provided email address
resource "aws_sns_topic_subscription" "email_notifications" {
  count = length(var.email_addresses)

  topic_arn = aws_sns_topic.backup_notifications.arn
  protocol = "email"
  endpoint = var.email_addresses[count.index]
  
  # Prevent Terraform from trying to confirm the subscriptions
  confirmation_timeout_in_minutes = 1
}

# S3 Bucket for backup file storage
# This bucket stores backup files and triggers notifcations on object creation
resource "aws_s3_bucket" "backup_bucket" {
  bucket = local.bucket_name

  # Prevent accidental deletion of bucket
  lifecycle {
    prevent_destroy = false
  }

  tags = merge(local.common_tags, {
    Name = "Backup Storage Bucket"
    Type = "Storage"
  })
}

# S3 Bucket Versioning Configuration
# Enables versioning for data protection and recovery
resource "aws_s3_bucket_versioning" "backup_bucket_versioning" {
  count = var.enable_s3_versioning ? 1 : 0

  bucket = aws_s3_bucket.backup_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Server-Side Encryption Configuration
# Encrypts objects at rest for security compliance
resource "aws_s3_bucket_server_side_encryption_configuration" "backup_bucket_encryption" {
  count = var.enable_s3_encryption ? 1 : 0

  bucket = aws_s3_bucket.backup_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = var.s3_encryption_algorithm == "aws:kms" ? true : false
  }
}

# S3 Bucket Public Access Block
# Prevents accidental public exposure of backup files
resource "aws_s3_bucket_public_access_block" "backup_bucket_pab" {
  bucket = aws_s3_bucket.backup_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


