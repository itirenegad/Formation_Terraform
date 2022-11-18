terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "elhadji_vm" {
  instance_type = "t2.micro"
  ami = "ami-076309742d466ad69"
  subnet_id = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  key_name = aws_key_pair.my_kp.key_name

  tags = {
    "Name" ="sncf_vm"
  }
}

resource "aws_vpc" "my_vpc" {

  cidr_block = "10.1.0.0/16"

  tags = {
    "Name" ="sncf_vm"
  }
}

resource "aws_internet_gateway" "my_gateway" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table" "my_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gateway.id
  }
}

resource "aws_route_table_association" "my-asso" {
    subnet_id = aws_subnet.my_subnet.id
    route_table_id = aws_route_table.my_table.id
}

resource "aws_security_group" "my_sg" {
  name = "my_sncf_sg"
  description = "Security group Formation"
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    "Name" ="sncf_vm"
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # Tous les protocols
    cidr_blocks      = ["0.0.0.0/0"]
  }

   ingress {
    description      = "Web from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}
resource "aws_subnet" "my_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "eu-central-1b"
  map_public_ip_on_launch = true

  tags = {
    "Name" ="sncf_vm"
  }

}

resource "aws_key_pair" "my_kp" {
  key_name = "my_ssh_kp"
  public_key = file("C:/Users/1Terra-04/Desktop/Formation_Terraform/aws/my_ssh_kp.pub")
}