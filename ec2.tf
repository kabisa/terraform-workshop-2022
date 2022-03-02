data "aws_ami" "bitnami_nginx" {
  most_recent = true
  owners      = ["979382823631"]

  filter {
    name   = "name"
    values = ["bitnami-nginx-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.bitnami_nginx.id
  instance_type = var.ec2_instance_type

  vpc_security_group_ids = [aws_security_group.instances.id]
  subnet_id              = module.vpc.public_subnets[0]

  user_data = templatefile("templates/user_data.sh.tpl", {
    team = var.team
  })

  root_block_device {
    volume_type = "gp2"
    volume_size = 16
  }
}
