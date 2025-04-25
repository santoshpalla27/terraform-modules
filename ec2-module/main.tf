resource "aws_instance" "main" {
  ami           = var.ami
  instance_type = var.instance_type
  iam_instance_profile = var.iam_instance_profile_name
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  tags = merge(
    var.tags,
    {
      Name = "${var.instance_name}"
    }
  )
  
}

