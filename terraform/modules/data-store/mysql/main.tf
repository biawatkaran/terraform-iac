resource "aws_db_instance" "terraform_training" {

  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  name = "${var.db_cluster_name}"
  username = "admin"
  password = "${var.db_password}"
  final_snapshot_identifier = "terraform-training"
  skip_final_snapshot = "true"
}