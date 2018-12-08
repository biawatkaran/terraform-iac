output "terraform_training_s3_arn" {

  value = "${aws_s3_bucket.terraform_training_bucket.arn}"
}