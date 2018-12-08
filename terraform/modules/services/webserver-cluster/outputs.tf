output "elb_dns_name" {

  value = "${aws_elb.terraform_training.dns_name}"
}

output "asg_name" {

  value = "${aws_autoscaling_group.terraform_training.name}"
}

output "elb_security_group_id" {

  value = "${aws_security_group.terraform_training_elb.id}"
}