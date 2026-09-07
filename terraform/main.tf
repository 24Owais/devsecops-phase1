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

# S3 bucket for storing app logs
resource "aws_s3_bucket" "app_logs" {
  bucket = "devsecops-app-logs-storage-bucket"
}