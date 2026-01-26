# Output values for the Simple File Backup Notifications infrastructure
# These outputs provide important information for verfication and integration

# S3 Bucket Information
output "s3_bucket_name" {
  description = "Name of the S3 bucket created for backup file storage"
  value       = aws_s3_bucket.backup_bucket.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket created for backup file storage"
  value       = aws_s3_bucket.backup_bucket.arn
}

output "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = aws_s3_bucket.backup_bucket.bucket_domain_name
}

output "s3_bucket_region" {
  description = "AWS region where the S3 bucket was created"
  value       = aws_s3_bucket.backup_bucket.region
}

output "s3_bucket_hosted_zone_id" {
  description = "Route 53 Hosted Zone ID for backup notificatons"
  value       = aws_s3_bucket.backup_bucket.hosted_zone_id
}
