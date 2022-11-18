provider "aws" {
  region = var.region
}


data "aws_ami" "ubuntu" {
  most_recent = true
#   owners      = [""]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

}
module "ec2" {
  source            = "./modules/ec2"
  instance_type     = var.instance_type
  ec2_ami           = data.aws_ami.ubuntu.id
  ec2_instance_name = var.ec2_instance_name
}

module "s3" {
  source  = "./modules/s3"
}
