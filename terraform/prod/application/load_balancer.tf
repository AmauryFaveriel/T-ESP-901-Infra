# Load-balancer instance and security group

resource "aws_instance" "load_balancer" {
  ami             = var.instance_ami
  instance_type   = var.instance_type
  count           = 1
  key_name        = var.application_key_name

  security_groups = [
    aws_security_group.load_balancer_security_group.name
  ]

  tags            = {
    Name      = "${var.stage}_${var.project}_load_balancer"
    component = "load_balancer"
    stage     = var.stage
    project   = var.project
  }
}

resource "aws_eip" "load_balancer_elastic_ip" {
  instance = aws_instance.load_balancer.0.id
}

resource "aws_security_group" "load_balancer_security_group" {
  name        = "${var.stage}-${var.project}-load_balancer-security-group"
  description = "Allow connection on port 22, 80, 443 and 8080 for load_balancer"

  ingress {
    description = "SSH access port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP load balancer port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS load balancer port"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Console load balancer port"
    from_port   = 8080
    to_port     = 8080
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