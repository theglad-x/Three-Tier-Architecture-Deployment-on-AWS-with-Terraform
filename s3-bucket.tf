resource "aws_s3_bucket" "tf_bucket" {
  bucket = "uglad-mytf-bucket"

  tags = {
    Name = my-tf-bucket
  }
}


resource "aws_s3_bucket_versioning" "tf_bucket_versioning" {
  bucket = aws_s3_bucket.tf_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "tf_bucket_pub_access" {
  bucket = aws_s3_bucket.tf_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}