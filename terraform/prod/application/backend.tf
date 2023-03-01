# back_end instance, security group

resource "aws_instance" "back_end" {
  ami             = var.instance_ami
  instance_type   = var.instance_type
  count           = var.back_end_instance_count
  key_name        = var.application_key_name

  security_groups = [
    aws_security_group.back_end_security_group.name
  ]

  tags            = {
    Name      = "${var.stage}_${var.project}_back_end"
    component = "back_end"
    stage     = var.stage
    project   = var.project
  }
}

resource "aws_eip" "back_end_elastic_ip" {
  count    = var.back_end_instance_count
  instance = element(aws_instance.back_end.*.id, count.index)
}

resource "aws_security_group" "back_end_security_group" {
  name        = "${var.stage}-${var.project}-back-end-security-group"
  description = "Allow connection on port 22 and 80 for back_end"

  ingress {
    description = "SSH access port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP back_end port"
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

resource "aws_s3_bucket" "back_end_bucket" {
  bucket = "${var.stage}-${var.project}-bucket"
  acl    = "public-read"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["https://backend.mrfvrl.fr"]
    max_age_seconds = 3000
  }
}
