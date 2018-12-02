provider "aws" {

  region = "us-east-1"
}

# ASG auto scale group for cloud cluster (instances)
resource "aws_launch_configuration" "terraform-training" {

  image_id = "ami-40d28157"
  instance_type = "t2.micro"

  #interpolation "${ResourceType.InstanceName.Atrribute}"
  security_groups = ["${aws_security_group.instance.id}"]

  #dummy web server
  user_data = <<-EOF
                #!/bin/bash
                echo "Hello , World" > index.html
                nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

/*
resource "aws_instance" "terraform-training" {

  ami = "ami-40d28157"
  instance_type = "t2.micro"

  #interpolation "${ResourceType.InstanceName.Atrribute}"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  #dummy web server
  user_data = <<-EOF
                #!/bin/bash
                echo "Hello , World" > index.html
                nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  tags {

    Name = "terraform-training"
  }
}

# output variable "terraform output public_ip"
output "public_ip" {

  value = "${aws_instance.terraform-training.public_ip}"
}
*/

# tells AWS into which availability zones EC2 should be deployed
data "aws_availability_zones" "all" {}

# ASG
resource "aws_autoscaling_group" "terraform-training-asg" {

  launch_configuration = "${aws_launch_configuration.terraform-training.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  # every EC2 instance registering itself to load balancer so ELB knows which EC2 instance to send requests
  load_balancers = ["${aws_elb.terraform-training-load-balancer-instance.name}"]
  health_check_type = "ELB"

  max_size = 10
  min_size = 2

  tag {
    key = "Name"
    propagate_at_launch = true
    value = "terraform-training-asg-instance"
  }
}

#load balancer
resource "aws_elb" "terraform-training-load-balancer-instance" {

  name = "terraform-training-asg"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups = ["${aws_security_group.elb.id}"]

  "listener" {
    instance_port = "${var.server_port}"
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    interval = 30
    target = "HTTP:${var.server_port}/"
    timeout = 3
    unhealthy_threshold = 2
  }
}

#EC2 does not allow incoming/outgoing traffic hence defined security group for EC2 instance running webserver
resource "aws_security_group" "instance"{

  name = "terraform-training-instance"

  ingress {

    from_port = "${var.server_port}"
    protocol = "tcp"
    to_port = "${var.server_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {

    create_before_destroy = true
  }

}

resource "aws_security_group" "elb" {

  name = "terraform-training-elb"

  # configures incoming request for elb
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = "${var.server_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allows to send out from elb say for health checks
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# input variables
# terraform plan -var server_port="8080"
variable "server_port" {

  description = "server port for HTTP requests"
  default = 8080
}

output "elb_dns_name" {

  value = "${aws_elb.terraform-training-load-balancer-instance.dns_name}"
}