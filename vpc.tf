data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.12"

  name = "cloud-legends-demo-${var.team}"

  cidr           = var.cidr
  azs            = data.aws_availability_zones.available.names
  public_subnets = var.public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true
}
