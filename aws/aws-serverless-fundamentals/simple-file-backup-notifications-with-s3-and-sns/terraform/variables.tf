variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "s3_bucket_prefix" {
  description = "Prefix for the S3 bucket name (will be combined with random suffix)"
  type        = string
  default     = "backup-notifications"
  
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.s3_bucket_prefix))
    error_message = "S3 bucket prefix must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "sns_topic_name" {
  description = "Name for the SNS topic (will be combined with random suffix)"
  type = string
  default = "backup-alerts"
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.sns_topic_name))
    error_message = "SNS topic name must contain only letters, numbers, hyphens, and underscores."
  }
}

variable "email_addresses" {
  description = "List of email addresses to receive backup notifications"
  type        = list(string)
  default     = []
  
  validation {
    condition = alltrue([
      for email in var.email_addresses : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))
    ])
    error_message = "At least one valid email address must be provided."
  }
}

variable "enable_s3_versioning" {
  description = "Enable versioning on the S3 bucket for data protection"
  type        = bool
  default     = true
}


variable "enable_s3_encryption" {
  description = "Enable server-side encryption on the S3 bucket"
  type        = bool
  default     = true
}

variable "s3_encryption_algorithm" {
  description = "Server-side encryption algorithm for S3 bucket"
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.s3_encryption_algorithm)
    error_message = "S3 encryption algorithm must be either 'AES256' or 'aws:kms'."
  }
}

variable "
