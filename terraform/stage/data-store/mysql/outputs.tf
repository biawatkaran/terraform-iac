output "address" {

  value = "${aws_db_instance.terraform_training.address}"
}

output "port" {

    value = "${aws_db_instance.terraform_training.port}"
}