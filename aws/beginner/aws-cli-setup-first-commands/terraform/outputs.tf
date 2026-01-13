# Outputs for AWS CLI Setup and First Commands Terraform Infrastructure
# These outputs provide essential information for using the created infrastructure

# S3 Bucket Information

output "s3_bucket_name" {
  description = "Name of the S3 bucket created for CLI tutorial"
  value       = aws_s3_bucket.cli_tutorial_bucket.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket created for CLI tutorial"
  value       = aws_s3_bucket.cli_tutorial_bucket.arn
}

output "s3_bucket_region" {
  description = "AWS region where the S3 bucket was created"
  value       = aws_s3_bucket.cli_tutorial_bucket.region
}

output "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = aws_s3_bucket.cli_tutorial_bucket.website_endpoint
}

output "s3_bucket_hosted_zone_id" {
  description = "Route 53 hosted zone for the S3 bucket"
  value = aws_s3_bucket.cli_tutorial_bucket.hosted_zone_id
}

# IAM Policy Information

output "s3_access_policy_arn" {
  description = "ARN of the IAM policy created for S3 access"
  value       = aws_iam_policy.cli_tutorial_s3_policy.arn
}

output "s3_access_policy_name" {
  description = "Name of the IAM policy for S3 access"
  value       = aws_iam_policy.cli_tutorial_s3_policy.name
}
