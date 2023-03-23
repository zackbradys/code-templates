resource "aws_s3_bucket" "s3_bucket" {
  bucket = "rancher-federal-repo"
  object_lock_enabled = false
  force_destroy = true

  versioning {
      enabled = true
      mfa_delete = false
  }
    
  grant {
      permissions = [
          "READ",
      ]
      type = "Group"
      uri = "http://acs.amazonaws.com/groups/global/AllUsers"
  }
  grant {
      permissions = [
          "READ",
      ]
      type = "Group"
      uri = "http://acs.amazonaws.com/groups/global/AuthenticatedUsers"
  }
  grant {
      id = "ddfc3e834845f7795d069c3b0aabba6df921b6cf18c6f1594c5f1f882fa77f43"
      permissions = [
          "FULL_CONTROL",
      ]
      type = "CanonicalUser"
  }
}

/* Upload Multiple Files
resource "aws_s3_bucket_object" "s3_object_$NAME" {
  for_each = fileset("$PATH/", "*")
  bucket = aws_s3_bucket.s3_bucket.id
  key = each.value
  acl = "public-read"
  force_destroy = true

  source = "$PATH/${each.value}"
  etag = filemd5("$PATH/${each.value}")
}
*/

/* Upload Single File
resource "aws_s3_object" "s3_object_$NAME" {
  bucket = aws_s3_bucket.s3_bucket.id
  key    = "$PATH"
  acl = "public-read"
  force_destroy = true

  source = "$PATH"
  etag = filemd5("$PATH")
}
*/
