
data "aws_vpc" "existing" {
  id = var.vpc_id
}

data "aws_subnet" "frontend" {
  id = var.frontend_subnet_id
}

data "aws_subnet" "backend" {
  id = var.backend_subnet_id
}
