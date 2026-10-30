
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_instance" "server" {
  ami           = var.ami
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  associate_public_ip_address = true

  vpc_security_group_ids = [
    var.security_group_id
  ]

  key_name  = var.key_name
  user_data = var.user_data

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "iac-cloud-init-${var.name}"
    Role = var.name
  }
}
