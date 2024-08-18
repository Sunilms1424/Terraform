provider "aws" {
    region = "us-east-1"
}

#creating vpc
resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr
    tags = {
        name = "myvpcforapp"
    }
}

#creating subnet
resource "aws_subnet" "mysub1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = var.availability_zone
    map_public_ip_on_launch = true

    tags = {
      name = "mypublicsubnet"
    }
}

# creating internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id

    tags = {
      name = "myinternetgateway"
    }
  
}

#creating route table 
resource "aws_route_table" "myrout1" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
        name = "myroutetable"
    }

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

# associate subnet with route table
resource "aws_route_table_association" "rtab1"{
    subnet_id = aws_subnet.mysub1.id
    route_table_id = aws_route_table.myrout1.id
}

resource "aws_security_group" "websec" {
    name = "web"
    vpc_id = aws_vpc.myvpc.id

# this is port for 80
    ingress {
        description = "http from vpc"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      name = "web-sg"
    }
  
}

# creating the ec2 instance
resource "aws_instance" "server" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_pair
    vpc_security_group_ids = [aws_security_group.websec.id]
    subnet_id = aws_subnet.mysub1.id

    connection {
      type = "ssh"
      user = "ubuntu"
      host = self.public_ip
 }
}