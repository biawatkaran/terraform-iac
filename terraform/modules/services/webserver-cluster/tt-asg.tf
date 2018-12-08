#EC2 does not allow incoming/outgoing traffic hence defined security group for EC2 instance running webserver
resource "aws_security_group" "terraform_training_instance"{

  name = "${var.cluster_name}-instance"

  lifecycle {

    create_before_destroy = true
  }

}

resource "aws_security_group_rule" "allow_http_inbound" {

  type = "ingress"
  security_group_id = "${aws_security_group.terraform_training_instance.id}"

  from_port = "${var.instance_port}"
  to_port = "${var.instance_port}"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# ASG auto scale group for cloud cluster (instances)
resource "aws_launch_configuration" "terraform_training" {

  image_id = "ami-872cc7e0"
  instance_type = "t2.micro"
  #interpolation "${ResourceType.InstanceName.Atrribute}"
  security_groups = ["${aws_security_group.terraform_training_instance.id}"]

  #dummy web server
  user_data = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}


# ASG
resource "aws_autoscaling_group" "terraform_training" {

  launch_configuration = "${aws_launch_configuration.terraform_training.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  # every EC2 instance registering itself to load balancer so ELB knows which EC2 instance to send requests
  load_balancers = ["${aws_elb.terraform_training.name}"]
  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key = "Name"
    value = "${var.cluster_name}"
    propagate_at_launch = true
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
                nohup busybox httpd -f -p "${var.instance_port}" &
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