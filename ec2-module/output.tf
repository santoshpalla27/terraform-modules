output "instance_id" {
  description = "The ID of the instance"
  value       = aws_instance.main.id
}

output "instance_public_ip" {
  description = "The public IP address of the instance"
  value       = aws_instance.main.public_ip
}

output "instance_private_ip" {
  description = "The private IP address of the instance"
  value       = aws_instance.main.private_ip
}

output "instance_ami" {
  description = "The AMI used for the instance"
  value       = aws_instance.main.ami
}

output "instance_iam_instance_profile" {
  description = "The IAM instance profile associated with the instance"
  value       = aws_instance.main.iam_instance_profile
}

output "instance_key_name" {
  description = "The key name used for the instance"
  value       = aws_instance.main.key_name
}

output "instance_subnet_id" {
  description = "The subnet ID of the instance"
  value       = aws_instance.main.subnet_id
}

output "instance_vpc_security_group_ids" {
  description = "The security group IDs associated with the instance"
  value       = aws_instance.main.vpc_security_group_ids
}