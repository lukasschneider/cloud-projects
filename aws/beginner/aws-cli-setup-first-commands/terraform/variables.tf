# Variables for AWS CLI Setup and First Commands Terraform Infrastructure
# These variables allow customization of the infrastrucuture for different
# environments and use cases.

variable "bucket_prefix" {
  description = "Prefix for S3 bucket name to ensure uniqueness."
  type        = string
  default     = "aws-cli-tutorial"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.bucket_prefix))
    error_message = "Bucket prefix must be between 3 and 63 characters, contain only lowercase letters, numbers, and hyphens, and not start or end with a hyphen"
  }
}

variable "environments" {
  description = "Environments name (e.g. dev, staging, prod, tutorial)."
  type        = string
  default     = "tutorial"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,20}$", var.environments))
    error_message = "Environment must be alphanumeric with hyphens, maximum 20 characters."
  }
}

variable "iam_policy_prefix" {
  description = "Prefix for IAM policy names to avoid conflicts."
  type        = string
  default     = "aws-cli-tutorial"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,50}$", var.iam_policy_prefix))
    error_message = "IAM policy prefix must be alphanumeric with hyphens, maximum 50 characters."
  }
}

variable "iam_role_prefix" {
  description = "Prefix for IAM roles names to avoid confilicts."
  type        = string
  default     = "aws-cli-tutorial"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,50}$", var.iam_role_prefix))
    error_message = "IAM role prefix must be alphanumeric with hyphens, maximum 50 characters."
  }
}

variable "create_ec2_role" {
  description = "Whether to create IAM role and instance profile for EC2-based CLI practice"
  type        = bool
  default     = false
}

variable "create_sample_objects" {
  description = "Whether to create sample objects in S3 bucket for CLI practice"
  type        = bool
  default     = true
}

variable "enable_cloudwatch_logging" {
  description = "Whether to create CloudWatch Log Group for monitoring CLI activities"
  type        = bool
  default     = false
}

variable "bucket_lifecycle_days" {
  description = "Number of days after which objects in the tutorial will be deleted"
  type       = number
  default    = 7

  validation {
    condition     = var.bucket_lifecycle_days > 0 && var.bucket_lifecycle_days <= 365
    error_message = "Bucket lifecycle days must be between 1 and 365."
  }
}

variable "cloudwatch_log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type = number
  default = 7
  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653
    ], var.cloudwatch_log_retention_days)
    error_message = "CloudWatch log retention days must be one of: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, or 3653 days."
  }
}

variable "enable_s3_versioning" {
  description = "Whether to enable S3 bucket versioning for the tutorial"
  type        = bool
  default     = true
}

variable "enable_bucket_encryption" {
  description = "Server-side encryption for S3 bucket"
  type        = bool
  default     = true
}


