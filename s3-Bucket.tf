provider "aws" {
  region = "us-west-2"
}

resource "aws_kms_key" "my_key" {
  description             = "KMS key for S3 bucket encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "cloud32-$(env)-${random.int}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.my_key.arn
      }
    }
  }
}