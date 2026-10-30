
variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "aws_account_id" {
  type    = string
  default = "170101435970"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0f94518e44a06f3cb"
}

variable "frontend_subnet_id" {
  type    = string
  default = "subnet-027102a64b0e792b7"
}

variable "backend_subnet_id" {
  type    = string
  default = "subnet-0c11c6c0fad580409"
}

variable "ubuntu_ami" {
  type    = string
  default = "ami-0fc53b217ec1ad816"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "volume_size" {
  type    = number
  default = 20
}

variable "ssh_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/iac-cloudinit.pub"
}
