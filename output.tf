output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "rds_username" {
  value = aws_db_instance.this.username
}

output "rds_password" {
  value     = aws_db_instance.this.password
  sensitive = true
}
