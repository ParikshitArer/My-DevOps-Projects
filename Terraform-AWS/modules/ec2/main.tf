data "aws_ami" "ubuntu" {

  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

}

resource "aws_instance" "ec2_instance" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  vpc_security_group_ids = [var.security_group_id]

  associate_public_ip_address = false

  iam_instance_profile = var.iam_instance_profile

  root_block_device {

    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true

  }

  tags = {

    Name        = "${var.project_name}-${var.environment}-ec2"
    Environment = var.environment

  }

}