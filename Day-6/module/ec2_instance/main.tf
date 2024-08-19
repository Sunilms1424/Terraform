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
resource "aws_instance" "examp" {
  ami=var.ami
  instance_type = var.instance_type
  tags = {
    name = "newone"
  }
}