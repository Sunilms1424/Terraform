variable "cidr" {
    description = "creating cidr for vpc"
    type = string
}
variable "availability_zone" {
  type = string
}
variable "ami" {
  type = string
}
variable "instance_type" {
    type = string
}
variable "key_pair" {
    type = string
}