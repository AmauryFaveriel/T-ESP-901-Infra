# Client instance, security group

resource "aws_instance" "client" {
  ami             = var.instance_ami
  instance_type   = var.instance_type
  count           = var.client_instance_count
  key_name        = var.application_key_name

  security_groups = [
    aws_security_group.client_security_group.name
  ]

  tags            = {
    Name      = "${var.stage}_${var.project}_client"
    component = "client"
    stage     = var.stage
    project   = var.project
  }
}

resource "aws_eip" "client_elastic_ip" {
  count    = var.client_instance_count
  instance = element(aws_instance.client.*.id, count.index)
}

resource "aws_security_group" "client_security_group" {
  name        = "${var.stage}-${var.project}-client-security-group"
  description = "Allow connection on port 22 and 80 for client"

  ingress {
    description = "SSH access port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP client port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
