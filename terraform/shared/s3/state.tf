terraform {

  backend "s3" {

    bucket = "terraform-training-bucket"
    key    = "shared/s3/terraform.tfstate"
    region = "eu-west-2"
    encrypt = "true"
  }
}
