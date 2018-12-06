provider "aws" {

  region = "eu-west-2"
}

resource "aws_db_instance" "terraform_training" {

  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  name = "terraform_training_db"
  username = "admin"
  password = "${var.db_password}"
}