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

  default_tags {
    tags = {
    provisioner = "terraform"
   }
 }
}

resource "aws_s3_bucket" "s3_bucket" {
    bucket                      = "rancher-repoistory"
    object_lock_enabled         = false
    force_destroy               = true

    versioning {
        enabled    = true
        mfa_delete = false
    }
    
    grant {
        permissions = [
            "READ",
            "READ_ACP",
        ]
        type        = "Group"
        uri         = "http://acs.amazonaws.com/groups/global/AllUsers"
    }
    grant {
        permissions = [
            "READ",
            "READ_ACP",
        ]
        type        = "Group"
        uri         = "http://acs.amazonaws.com/groups/global/AuthenticatedUsers"
    }
    grant {
        id          = "ddfc3e834845f7795d069c3b0aabba6df921b6cf18c6f1594c5f1f882fa77f43"
        permissions = [
            "FULL_CONTROL",
        ]
        type        = "CanonicalUser"
    }
}
