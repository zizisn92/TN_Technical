variable "environment" {}
variable "application" {}
variable "instance_type" {
  default = "t2.micro"
}
variable "subnet_id" {}
variable "key_name" {
  default = "terraform"
}
variable "associate_public_ip_address" {
  default = false
}
variable "enable_api_termination" {
  default = false
}
variable "security_group" {}
