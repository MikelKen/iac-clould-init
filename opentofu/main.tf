
resource "aws_key_pair" "lab" {
  key_name_prefix = "lab-key-"

  public_key = trimspace(
    file(pathexpand(var.ssh_public_key_path))
  )

  tags = {
    Project = "iac-cloud-init"
  }
}

resource "aws_security_group" "frontend" {
  name_prefix = "frontend-sg-"
  description = "SSH publico - laboratorio temporal"
  vpc_id      = data.aws_vpc.existing.id

  ingress {
    description = "SSH laboratorio"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    description = "Salida a Internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Role = "frontend"
  }
}

resource "aws_security_group" "backend" {
  name_prefix = "backend-sg-"
  description = "SSH publico - laboratorio temporal"
  vpc_id      = data.aws_vpc.existing.id

  ingress {
    description = "SSH laboratorio"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    description = "Salida a Internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Role = "backend"
  }
}

module "frontend" {
  source = "./modules/ec2-server"

  name              = "frontend"
  ami               = var.ubuntu_ami
  instance_type     = var.instance_type
  subnet_id         = data.aws_subnet.frontend.id
  security_group_id = aws_security_group.frontend.id
  key_name          = aws_key_pair.lab.key_name
  volume_size       = var.volume_size

  user_data = file(
    "${path.module}/../cloud-init/frontend.yaml"
  )
}

module "backend" {
  source = "./modules/ec2-server"

  name              = "backend"
  ami               = var.ubuntu_ami
  instance_type     = var.instance_type
  subnet_id         = data.aws_subnet.backend.id
  security_group_id = aws_security_group.backend.id
  key_name          = aws_key_pair.lab.key_name
  volume_size       = var.volume_size

  user_data = file(
    "${path.module}/../cloud-init/backend.yaml"
  )
}
