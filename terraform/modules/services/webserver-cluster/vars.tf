# input variables
# terraform plan -var instance_port="8080"
variable "instance_port" {

  description = "server port for HTTP requests"
  default = 8080
}

variable "elb_port" {

  description = "load balance server port for HTTP requests"
  default = 80
}

variable "cluster_name" {

  description = "The name to be used for cluster"
}

variable "db_remote_state_key" {

  description = "S3 path for db remote state"
}