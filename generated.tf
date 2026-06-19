provider "aws" {
  region = var.region
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "example" {
  bucket = "${var.bucket_name_prefix}-${random_id.suffix.hex}"
  tags = {
    Name = "Terraform-managed S3 bucket"
  }
  force_destroy = true
}

resource "aws_s3_bucket" "example_dev" {
  bucket = "${var.bucket_name_prefix}-dev-${random_id.suffix.hex}"
  tags = {
    Name = "Terraform-managed S3 bucket dev"
  }
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "example_dev" {
  bucket = aws_s3_bucket.example_dev.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = "alias/aws/s3"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example_dev" {
  bucket = aws_s3_bucket.example_dev.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = "alias/aws/s3"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "example_dev" {
  bucket = aws_s3_bucket.example_dev.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}

output "bucket_name_dev" {
  value = aws_s3_bucket.example_dev.bucket
}
