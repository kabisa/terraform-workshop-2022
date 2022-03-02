output "ec2_dns_name" {
  value = aws_instance.this.public_dns
}
