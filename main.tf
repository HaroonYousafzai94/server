#######provider##########

provider "aws" {
  region     = "us-east-2"
  access_key = "" #paste access key of the aws user account
  secret_key = "" # Paste the secret key of aws user account
}
####### aws_vpc##########
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}
####### internet gateway##########
resource "aws_internet_gateway" "myig" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "igw"
  }
}
####### Public subnet##########
resource "aws_subnet" "dicesubnet1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "dicesubnet1"
  }
}

resource "aws_subnet" "dicesubnet2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "subnet dicesubnet2"
  }
}
####### Route table ##########
resource "aws_route_table" "myroutetable" {
  vpc_id = aws_vpc.myvpc.id

  route = []

  tags = {
    Name = "route table for my vpc"
  }
}
####### aws_route##########
resource "aws_route" "myroute" {
  route_table_id            = aws_route_table.myroutetable.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.myig.id
  depends_on = [ aws_route_table.myroutetable ]
}
####### security group##########
resource "aws_security_group" "mysgw" {
  name   = "allow all traffic"
  vpc_id = aws_vpc.myvpc.id

  ingress  {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    #prefix_list_ids = [aws_vpc_endpoint.my_endpoint.prefix_list_id]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
  }
  
}
####### aws_route table association##########
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.dicesubnet1.id
  route_table_id = aws_route_table.myroutetable.id
}
####### aws_instance##########
resource "aws_instance" "tcw" {
  ami           = "ami-0490fddec0cbeb88b" # us-west-2
  subnet_id = aws_subnet.dicesubnet1.id
  instance_type = "t2.micro"

}
