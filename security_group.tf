resource "aws_security_group" "instances" {
  name   = "cloud-legends-demo-${var.team}"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "http" {
  security_group_id        = aws_security_group.instances.id
  source_security_group_id = aws_security_group.alb.id

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
}

resource "aws_security_group_rule" "https" {
  security_group_id        = aws_security_group.instances.id
  source_security_group_id = aws_security_group.alb.id

  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
}

resource "aws_security_group_rule" "egress_all" {
  security_group_id = aws_security_group.instances.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "alb" {
  name   = "cloud-legends-demo-${var.team}-alb"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  protocol    = "tcp"
}

resource "aws_security_group_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id

  type        = "ingress"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
  protocol    = "tcp"
}

resource "aws_security_group_rule" "alb_egress_instances" {
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = aws_security_group.instances.id

  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"
}

resource "aws_security_group" "rds" {
  name   = "cloud-legends-demo-${var.team}-rds"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "rds_mysql" {
  security_group_id = aws_security_group.rds.id

  type        = "ingress"
  from_port   = 3306
  to_port     = 3306
  cidr_blocks = ["0.0.0.0/0"]
  protocol    = "tcp"
}
