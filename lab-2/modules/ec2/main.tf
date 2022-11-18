resource "aws_instance" "elhadji_vm" {
  instance_type          = var.instance_type
  ami                    = var.ec2_ami
  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  key_name               = aws_key_pair.my_kp.key_name
  tags = {
    "Name" = var.ec2_instance_name
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    "Name" = "sncf_vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "sncf_subnet"
  }
}

resource "aws_security_group" "my_sg" {
  name        = "my_sncf_sg"
  description = "Security group Formation"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    "Name" = "sncf_vm"
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Tous les protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Web from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "my_kp" {
  key_name   = "my_ssh_kp"
  public_key = file("C:/Users/1Terra-04/Desktop/Formation_Terraform/aws/my_ssh_kp.pub")
}