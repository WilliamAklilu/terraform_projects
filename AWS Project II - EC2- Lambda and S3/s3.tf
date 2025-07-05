resource "aws_s3_bucket" "bucket" {
    bucket = "${var.project_name}-bucket"
  
}

resource "aws_s3_bucket_public_access_block" "aws_s3_bucket_public_access_block" {
    bucket = aws_s3_bucket.bucket.id
    block_public_acls = true
    ignore_public_acls = true
    block_public_policy = true
    restrict_public_buckets = true
  
}