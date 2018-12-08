provider "aws" {

  region = "eu-west-2"
}

module "mysql_cluster" {

  source = "../../../modules/data-store/mysql"

  db_cluster_name = "terraform_training_stage_db"
  db_password = "${var.db_password}"
}