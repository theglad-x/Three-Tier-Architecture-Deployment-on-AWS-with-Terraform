terraform {
  backend "s3" {
    bucket = "uglad-mytf-bucket"
    key    = "terraform-bucket/terraform.tfstate"
    region = "us-east-1"
  }
}