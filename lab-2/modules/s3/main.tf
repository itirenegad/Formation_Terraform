resource "aws_s3_bucket" "my_sncf_elj_s3" {
  bucket = var.bucket_name
  aws_s3_bucket_acl    = "private"
}
