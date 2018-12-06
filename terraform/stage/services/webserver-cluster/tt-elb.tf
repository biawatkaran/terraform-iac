resource "aws_security_group" "elb_terraform_training" {

  name = "elb-terraform-training"

  # configures incoming request for elb
  ingress {

    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allows to send out from elb say for health checks
  egress {

    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#load balancer
resource "aws_elb" "terraform_training" {

  name = "terraform-training"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups = ["${aws_security_group.elb_terraform_training.id}"]

  listener {

    lb_port = "${var.server_port}"
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }

  health_check {

    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${var.server_port}/"
  }
}
