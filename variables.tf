variable "bucket_name" {
  default     = null
  description = "Name to use for bucket (optionally leave blank and use `bucket_suffix`)"
  type        = string
}

variable "bucket_suffix" {
  default     = "bucket"
  description = "Suffix to apply to bucket, which will be created in format [ACCOUNT_ID]-[REGION]-cloudberry-[BUCKET_SUFFIX]. This is not used if `bucket_name` is set to a non-null value."
  type        = string
}

variable "cloudberry_account" {
  default     = "626709717326"
  description = "AWS Account ID for CloudBerry"
  type        = string
}

variable "iam_role_arn" {
  default     = null
  description = "If an existing CloudBerry IAM role already exists, specify it here. The new policy will be attached to the role."
  type        = string
}

variable "kms_key_id" {
  default     = null
  description = "KMS Key ID for Bucket encryption (default used if not specified)"
  type        = string
}

variable "lifecycle_rules" {
  default     = []
  description = "lifecycle rules to apply to the bucket"

  type = list(object(
    {
      id                            = string
      enabled                       = bool
      prefix                        = string
      expiration                    = number
      noncurrent_version_expiration = number
  }))
}

variable "s3_access_logging_bucket" {
  default     = null
  description = "Optional target for S3 access logging"
  type        = string
}

variable "s3_access_logging_prefix" {
  default     = null
  description = "Optional target prefix for S3 access logging (only used if `s3_access_logging_bucket` is set)"
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags to apply to supported resources"
  type        = map(string)
}

variable "versioning_enabled" {
  default     = false
  description = "enable versioning on bucket (be mindful of cost if doing so)"
  type        = bool
}
