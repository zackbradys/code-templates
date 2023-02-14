terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "demo-bucket"{
  bucket = "aws-demo-bucket"

  tags = {
    Name = "demo-bucket"
  }
}