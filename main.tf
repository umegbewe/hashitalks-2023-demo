provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_traffic" {
  name        = "allow_http"
  description = "Allow inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "packer-ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["hashitalks-africa*"]
  }

  owners = ["self"]
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.packer-ami.id
  instance_type = "t2.micro"
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.allow_traffic.id]
  subnet_id              = var.subnet_id

  tags = {
    Name = "AppServer"
  }
}
