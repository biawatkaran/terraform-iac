# input variables
# terraform plan -var server_port="8080"
variable "server_port" {

  description = "server port for HTTP requests"
  default = 8080
}