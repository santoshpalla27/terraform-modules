variable "ami" {
  description = "The AMI to use for the instance"
  type        = string
  default     = "ami-0e449927258d45bc4" # Amazon Linux 2 AMI
  
}

variable "instance_name" {
  description = "The name of the instance"
  type        = string
  default     = ""
}

variable "iam_instance_profile_name" {
  description = "The IAM instance profile to associate with the instance"
  type        = string
  default     = ""
}
variable "instance_type" {
  description = "The type of instance to create"
  type        = string
}
variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the instance in"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "The security group IDs to associate with the instance"
  type        = list(string)
}

variable "tags" {
  description = "Tags to assign to the instance"
  type        = map(string)
  default     = {}
}


variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = true
}