terraform {

  backend "s3" {

    bucket = "terraform-training-bucket"
    key = "stage/services/webserver-cluster/terraform.tfstate"
    region = "eu-west-2"
    encrypt = "true"
  }
}