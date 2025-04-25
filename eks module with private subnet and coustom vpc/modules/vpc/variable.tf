variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "public_subnet" {
  description = "The CIDR block for the public subnet"
  type        = list(string)
}

variable "private_subnet" {
  description = "The CIDR block for the private subnet"
  type        = list(string)
}


variable "availability_zones_public" {
  description = "The availability zones to use for public subnets"
  type        = list(string)
}

variable "private_availability_zone" {
  description = "The availability zone for the private subnet"
  type        = list(string)
}