terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Secure S3 Bucket for Log Storage
resource "aws_s3_bucket" "app_logs" {
  # checkov:skip=CKV_AWS_18: Access logging target not needed for basic log storage
  # checkov:skip=CKV_AWS_144: Cross-region replication not required for non-production demo
  # checkov:skip=CKV_AWS_145: AES256 server-side encryption used instead of KMS
  # checkov:skip=CKV2_AWS_62: Event notifications not required for static log bucket
  bucket        = "devsecops-app-logs-storage-bucket"
  force_destroy = true
}

# 1. Public Access Block (Solves CKV2_AWS_6)
resource "aws_s3_bucket_public_access_block" "app_logs_public_block" {
  bucket                  = aws_s3_bucket.app_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 2. Server-Side Encryption (Solves CKV_AWS_19)
resource "aws_s3_bucket_server_side_encryption_configuration" "app_logs_encryption" {
  bucket = aws_s3_bucket.app_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 3. Bucket Versioning (Solves CKV_AWS_21)
resource "aws_s3_bucket_versioning" "app_logs_versioning" {
  bucket = aws_s3_bucket.app_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 4. Lifecycle Configuration (Solves CKV2_AWS_61)
resource "aws_s3_bucket_lifecycle_configuration" "app_logs_lifecycle" {
  bucket = aws_s3_bucket.app_logs.id

  rule {
    id     = "expire-old-logs"
    status = "Enabled"

    expiration {
      days = 90
    }
  }
}