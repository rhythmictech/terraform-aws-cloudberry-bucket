data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}

locals {
  account_id   = data.aws_caller_identity.current.account_id
  bucket_name  = var.bucket_name == null ? "${local.account_id}-${local.region}-cloudberry-${var.bucket_suffix}" : var.bucket_name
  iam_role_arn = var.iam_role_arn == null ? aws_iam_role.this[0].id : var.iam_role_arn
  region       = data.aws_region.current.name

  logging = var.s3_access_logging_bucket == null ? [] : [{
    bucket = var.s3_access_logging_bucket
    prefix = var.s3_access_logging_prefix
  }]
}

#tfsec:ignore:AWS002
resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name
  acl    = "private"
  tags   = var.tags

  dynamic "lifecycle_rule" {
    iterator = rule
    for_each = var.lifecycle_rules

    content {
      id      = rule.value.id
      enabled = rule.value.enabled
      prefix  = lookup(rule.value, "prefix", null)

      expiration {
        days = rule.value.expiration
      }

      noncurrent_version_expiration {
        days = rule.value.noncurrent_version_expiration
      }
    }
  }

  dynamic "logging" {
    iterator = log
    for_each = local.logging

    content {
      target_bucket = log.value.bucket
      target_prefix = lookup(log.value, "prefix", null)
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = var.kms_key_id
      }
    }
  }

  versioning {
    enabled = var.versioning_enabled
  }

  # this cannot be configured programatically via TF, so just ignore it if someone
  # turned it on administratively.
  lifecycle {
    ignore_changes = [versioning[0].mfa_delete]
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "assume" {

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.cloudberry_account}:root"]
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.iam_role_arn == null ? 1 : 0

  name_prefix = "CloudBerry-Bucket-Access"

  assume_role_policy   = data.aws_iam_policy_document.assume.json
  max_session_duration = 7200
  path                 = "/"
  tags                 = var.tags
}

data "aws_iam_policy_document" "this" {

  statement {
    effect    = "Allow"
    actions   = ["s3:*Object", "s3:*Version"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.this.id}/*"]
  }

  statement {
    effect    = "Allow"
    resources = ["arn:aws:s3:::${aws_s3_bucket.this.id}"]

    actions = [
      "s3:ListBucket",
      "s3:Get*"
    ]
  }

  statement {
    effect    = "Deny"
    actions   = ["s3:DeleteBucket"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.this.id}"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["sts:GetFederationToken"]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ses:*"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "this" {
  name_prefix = "cloudberry-"
  role        = local.iam_role_arn
  policy      = data.aws_iam_policy_document.this.json
}
