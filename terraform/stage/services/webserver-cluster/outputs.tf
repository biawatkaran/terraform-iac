output "elb_dns_name" {

  value = "${aws_elb.terraform_training.dns_name}"
}