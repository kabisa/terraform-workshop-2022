resource "random_password" "rds" {
  length  = 16
  special = false
}

resource "aws_db_subnet_group" "default" {
  name       = "default-${var.team}"
  subnet_ids = module.vpc.public_subnets
}

resource "aws_db_instance" "this" {
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t4g.micro"
  db_name                = replace(var.team, "-", "_")
  username               = "superuser"
  password               = random_password.rds.result
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = true
}
