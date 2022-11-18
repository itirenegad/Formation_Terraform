variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "instance_type" {
  type    = string
  default = "t3_micro"
}

variable "ec2_ami" {
  type    = string
  default = ""

}

variable "ec2_instance_name" {
  type    = string
  default = ""

}