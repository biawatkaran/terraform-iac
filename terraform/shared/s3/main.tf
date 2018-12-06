provider "aws" {

  region = "eu-west-2"
}

resource "aws_s3_bucket" "terraform_training_bucket" {

  bucket = "${var.bucket_name}"

  versioning {

    enabled = true
  }

  lifecycle {

    //prevent_destroy = true
  }
}