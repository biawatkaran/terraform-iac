# tells AWS into which availability zones EC2 should be deployed
data "aws_availability_zones" "all" {}

# access S3 bucket to read tfstate of another infra e.g. to read outputs of data-store tf
data "terraform_remote_state" "db" {

  backend = "s3"

  config {

    bucket = "terraform-training-bucket"
    key = "${var.db_remote_state_key}"
    region = "eu-west-2"
  }
}


data "template_file" "user_data" {

  template = "${file("${path.module}/user-data.sh")}"

  vars{

    instance_port = "${var.instance_port}"
    db_address = "${data.terraform_remote_state.db.address}"
    db_port = "${data.terraform_remote_state.db.port}"
  }
}
