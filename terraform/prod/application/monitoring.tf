# Monitoring instance and security group

resource "aws_instance" "monitoring" {
  ami             = var.instance_ami
  instance_type   = var.instance_type
  count           = var.monitoring_instance_count
  key_name        = var.application_key_name

  security_groups = [
    aws_security_group.monitoring_security_group.name
  ]

  tags            = {
    Name      = "${var.stage}_${var.project}_monitoring"
    component = "monitoring"
    stage     = var.stage
    project   = var.project
  }
}

resource "aws_eip" "monitoring_elastic_ip" {
  instance = aws_instance.monitoring.0.id
}

resource "aws_security_group" "monitoring_security_group" {
  name        = "${var.stage}-${var.project}-monitoring-security-group"
  description = "Allow connection on port 22, 80 and 8086 for monitoring"

  ingress {
    description = "SSH access port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP monitoring client port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP monitoring database port"
    from_port   = 8086
    to_port     = 8086
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