provider "aws" {

  region = "eu-west-2"
}

module "webserver_cluster" {

  source = "../../../modules/services/webserver-cluster"

  cluster_name = "terraform-training-stage"
  db_remote_state_key = "stage/data-store/mysql/terraform.tfstate"
}

// once defined as resource within module can be kind of overwritten for testing purpose in staging env
resource "aws_security_group_rule" "allow_testing_inbound" {

  type = "ingress"
  security_group_id = "${module.webserver_cluster.elb_security_group_id}"

  from_port = 9999
  to_port = 9999
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}