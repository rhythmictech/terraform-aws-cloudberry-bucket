# terraform-aws-cloudberry-bucket

Creates and manages an S3 bucket intended for use by [CloudBerry](https://www.msp360.com/managed-backup.aspx) (now MSP360). This module outputs the bucket name and IAM role needed by CloudBerry.

[![tflint](https://github.com/rhythmictech/terraform-aws-cloudberry-bucket/workflows/tflint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-cloudberry-bucket/actions?query=workflow%3Atflint+event%3Apush+branch%3Amaster)
[![tfsec](https://github.com/rhythmictech/terraform-aws-cloudberry-bucket/workflows/tfsec/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-cloudberry-bucket/actions?query=workflow%3Atfsec+event%3Apush+branch%3Amaster)
[![yamllint](https://github.com/rhythmictech/terraform-aws-cloudberry-bucket/workflows/yamllint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-cloudberry-bucket/actions?query=workflow%3Ayamllint+event%3Apush+branch%3Amaster)
[![misspell](https://github.com/rhythmictech/terraform-aws-cloudberry-bucket/workflows/misspell/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-cloudberry-bucket/actions?query=workflow%3Amisspell+event%3Apush+branch%3Amaster)
[![pre-commit-check](https://github.com/rhythmictech/terraform-aws-cloudberry-bucket/workflows/pre-commit-check/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-cloudberry-bucket/actions?query=workflow%3Apre-commit-check+event%3Apush+branch%3Amaster)
<a href="https://twitter.com/intent/follow?screen_name=RhythmicTech"><img src="https://img.shields.io/twitter/follow/RhythmicTech?style=social&logo=twitter" alt="follow on Twitter"></a>

## Example
Here's what using the module will look like
```hcl
module "cloudberry-infra-bucket" {
  source = "rhythmictech/cloudberry-bucket/aws"

  bucket_suffix            = "documents"
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.19 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_name | Name to use for bucket (optionally leave blank and use `bucket_suffix`) | `string` | `null` | no |
| bucket\_suffix | Suffix to apply to bucket, which will be created in format [ACCOUNT\_ID]-[REGION]-cloudberry-[BUCKET\_SUFFIX]. This is not used if `bucket_name` is set to a non-null value. | `string` | `"bucket"` | no |
| cloudberry\_account | AWS Account ID for CloudBerry | `string` | `"626709717326"` | no |
| iam\_role\_arn | If an existing CloudBerry IAM role already exists, specify it here. The new policy will be attached to the role. | `string` | `null` | no |
| kms\_key\_id | KMS Key ID for Bucket encryption (default used if not specified) | `string` | `null` | no |
| lifecycle\_rules | lifecycle rules to apply to the bucket | <pre>list(object(<br>    {<br>      id                            = string<br>      enabled                       = bool<br>      prefix                        = string<br>      expiration                    = number<br>      noncurrent_version_expiration = number<br>  }))</pre> | `[]` | no |
| s3\_access\_logging\_bucket | Optional target for S3 access logging | `string` | `null` | no |
| s3\_access\_logging\_prefix | Optional target prefix for S3 access logging (only used if `s3_access_logging_bucket` is set) | `string` | `null` | no |
| tags | Tags to apply to supported resources | `map(string)` | `{}` | no |
| versioning\_enabled | enable versioning on bucket (be mindful of cost if doing so) | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| iam\_role\_arn | IAM role ARN |
| s3\_bucket\_name | Name of bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
