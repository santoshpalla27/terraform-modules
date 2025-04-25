variable "instance_ami" {
  description = "The AMI to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to launch"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID to launch the instance in"
  type        = string
}
variable "instance_name" {
  description = "The name of the instance"
  type        = string
}
variable "iam_instance_profile" {
  description = "The IAM instance profile to associate with the instance"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID to associate with the instance"
  type        = string
}
variable "key_name" {
  description = "The key name to associate with the instance"
  type        = string
}