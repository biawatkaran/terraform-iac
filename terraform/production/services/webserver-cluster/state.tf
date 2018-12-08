terraform {

  backend "s3" {

    bucket = "terraform-training-bucket-s3"
    key = "prod/services/webserver-cluster/terraform.tfstate"
    region = "eu-west-2"
    encrypt = "true"
  }
}