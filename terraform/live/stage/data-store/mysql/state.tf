terraform {

  backend "s3" {

    bucket = "terraform-training-bucket"
    key = "stage/data-store/mysql/terraform.tfstate"
    region = "eu-west-2"
    encrypt = "true"
  }
}