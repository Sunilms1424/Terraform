#create vpc 
resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr
    tags = {
        Name = "myvpc1"
    }
}
#creating public_subnet_1 for vpc
resource "aws_subnet" "mypublicsub1" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "us-east-1a"
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true
    tags = {
      Name = "mypublicsubnet1"
    }
}
resource "aws_subnet" "myprivatesub1" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "us-east-1a"
    cidr_block = "10.0.1.0/24"
    tags = {
      Name = "myprivatesubnet1"
    }
}
resource "aws_subnet" "mypublicsub2" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "us-east-2a"
    cidr_block = "10.0.2.0/24"
    tags = {
        Name = "mypublicsubnet2"
    }
}
resource "aws_subnet" "myprivatesub2" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "us-east-2a"
    cidr_block = "10.0.3.0/24"
    tags = {
      Name = "myprivatesubnet2"
    }
}
resource "aws_internet_gateway" "myigw" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
      Name = var.igw
    }
}

resource "aws_route_table" "mypublic-route" {
    vpc_id = aws_vpc.myvpc.id

    tags = {
      Name = "mypublic-routetable"
    }
    
    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myigw.id
    }
}
resource "aws_route_table" "myprivate-route-1" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
      Name = "myprivate-routetable-1"
    }
}
resource "aws_route_table" "myprivate-route-2" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
      Name = "myprivate-routetable-2"
    }
}

resource "aws_route_table_association" "myroutetable_associate_pubsub1" {  
    route_table_id = aws_route_table.mypublic-route.id
    subnet_id = aws_subnet.mypublicsub1.id
}
resource "aws_route_table_association" "myroutetable_associate_pubsub2" {
    route_table_id = aws_route_table.mypublic-route.id
    subnet_id = aws_subnet.myprivatesub2.id
}
resource "aws_route_table_association" "myroutetable_associate_private1" {
    route_table_id = aws_route_table.myprivate-route-1.id
    subnet_id = aws_subnet.myprivatesub1.id
}
resource "aws_route_table_association" "myroutetable_associate_private" {
    route_table_id = aws_route_table.myprivate-route-2.id
    subnet_id = aws_subnet.myprivatesub2.id
  
}