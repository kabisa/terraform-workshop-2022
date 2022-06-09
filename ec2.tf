data "aws_ami" "bitnami_nginx" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220606"]
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
  count         = local.instance_count
  ami           = data.aws_ami.bitnami_nginx.id
  instance_type = var.ec2_instance_type

  vpc_security_group_ids = [aws_security_group.instances.id]
  subnet_id              = module.vpc.public_subnets[0]

  user_data = templatefile("templates/user_data.sh.tpl", {
    team     = var.team
    instance = count.index

    db_host     = aws_db_instance.this.address
    db_name     = aws_db_instance.this.db_name
    db_username = aws_db_instance.this.username
    db_password = aws_db_instance.this.password
  })

  root_block_device {
    volume_type = "gp2"
    volume_size = 16
  }
}
