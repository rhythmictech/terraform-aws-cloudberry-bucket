
output "s3_bucket_name" {
  description = "Name of bucket"
  value       = aws_s3_bucket.this.bucket
}

output "iam_role_arn" {
  description = "IAM role ARN"
  value       = local.iam_role_arn
}
