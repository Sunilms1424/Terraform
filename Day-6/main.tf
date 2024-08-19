provider "aws" {
  region = "us-east-1"
}
variable "ami" {
  description = "this the ami for instance"
  type = string
}
variable "instance_type" {
  description = "this the instance-type for instance"
  type = string
}
module "ec2_instance" {
  source = "./module/ec2_instance"
  ami = var.ami
  instance_type = var.instance_type
}