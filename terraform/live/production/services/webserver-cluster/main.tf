provider "aws" {

  region = "eu-west-2"
}

module "webserver_cluster" {

  source = "../../../modules/services/webserver-cluster"

  cluster_name = "terraform-training-prod"
  db_remote_state_key = "prod/data-store/mysql/terraform.tfstate"
}

resource "aws_autoscaling_schedule" "scale_out" {

  autoscaling_group_name = "${module.webserver_cluster.asg_name}"

  scheduled_action_name = "scale-out-during-business-hours"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 10
  recurrence            = "0 9 * * *"
}

resource "aws_autoscaling_schedule" "scale_in" {

  autoscaling_group_name = "${module.webserver_cluster.asg_name}"

  scheduled_action_name = "scale-in-at-night"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 2
  recurrence            = "0 17 * * *"
}