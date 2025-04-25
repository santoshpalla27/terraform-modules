terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" # Change this to your desired region
}

data "aws_availability_zones" "az" {
  state = "available"
}

output "az" {
  value = data.aws_availability_zones.az
}

output "azs" {
  value = data.aws_availability_zones.az.names
}

