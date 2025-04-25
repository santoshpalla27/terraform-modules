resource "aws_instance" "name" {
  ami = var.instance_ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  tags = {
    Name = "${var.instance_name}"
  }
  iam_instance_profile = var.iam_instance_profile
  security_groups = [var.security_group_id]
  key_name = var.key_name
}