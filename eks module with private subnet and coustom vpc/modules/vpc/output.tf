output "allow_ssh_sg_id" {
  value = aws_security_group.allow_ssh.id
}
output "main_server_sg_id" {
  value = aws_security_group.main_server.id
}

output "public_subnet_id" {
  value = aws_subnet.public[*].id
}

output "private_subnet_id" {
  value = aws_subnet.private[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}