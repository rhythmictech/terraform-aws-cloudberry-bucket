module "cloudberry-infra-bucket" {
  source = "rhythmictech/cloudberry-bucket/aws"

  bucket_suffix = "documents"
}
