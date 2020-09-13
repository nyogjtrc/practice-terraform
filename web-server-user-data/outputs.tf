output "vpc_id" {
  description = "ID of VPC"
  value       = aws_vpc.this.id
}

output "web_instance_id" {
  description = "ID of web instance"
  value       = aws_instance.web.id
}

output "web_public_ip" {
  description = "Public IP of web server"
  value       = aws_instance.web.public_ip
}

