resource "aws_security_group" "terraform_training_elb" {

  name = "${var.cluster_name}-elb"
}


# configures incoming request for elb
resource "aws_security_group_rule" "elb_http_inbound" {

  type = "ingress"
  security_group_id = "${aws_security_group.terraform_training_elb.id}"

  from_port = "${var.elb_port}"
  to_port = "${var.elb_port}"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}


# allows to send out from elb say for health checks
resource "aws_security_group_rule" "elb_http_outbound" {

  type = "egress"
  security_group_id = "${aws_security_group.terraform_training_elb.id}"

  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}


#load balancer
resource "aws_elb" "terraform_training" {

  name = "${var.cluster_name}-elb"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups = ["${aws_security_group.terraform_training_elb.id}"]

  listener {

    lb_port = "${var.elb_port}"
    lb_protocol = "http"
    instance_port = "${var.instance_port}"
    instance_protocol = "http"
  }

  health_check {

    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${var.instance_port}/"
  }
}
