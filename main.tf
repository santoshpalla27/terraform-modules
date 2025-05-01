variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
  default     = "main_vpc"
}

module "vpc" {
  source             = "./vpc-module"
  region             = "us-east-1"
  vpc_name           = "main"
  cidr_block         = "10.0.0.0/16"
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  create_nat_gateway = true
  single_nat_gateway = true
  tags = {
    Environment = "dev"
    Project     = "vpc-module"
  }

  public_subnets_tags = {
    "kubernetes.io/cluster/${var.vpc_name}" = "shared"
    "kubernetes.io/role/elb"                = "1"
  }
  private_subnets_tags = {
    "kubernetes.io/cluster/${var.vpc_name}" = "shared"
    "kubernetes.io/role/internal-elb"       = "1"
  }
}

module "https-sg" {
  source = "./sg-module"
  sg_name = "additonal-sg"
  vpc_id = module.vpc.vpc_id
  sg_description = "SSH Security Group"
  ingress = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "https access"
    }
  ]
  egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
}




module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.31.6"
  cluster_name    = "three-tier-project"
  cluster_version = "1.31"

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  cluster_additional_security_group_ids = [module.https-sg.sg_id]

  eks_managed_node_groups = {
    nodes = {
      min_size      = 1
      max_size      = 3
      desired_size  = 2
      instance_type = "t2.medium"
      key_name      = "santosh"
    }
  }
  depends_on = [ module.https-sg ]
}


resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "admin_policy_attachment" {
  role = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "admin-instance-profile"
  role = aws_iam_role.ec2_role.name
}


module "ssh-sg" {
  source = "./sg-module"
  sg_name = "ssh-sg"
  vpc_id = module.vpc.vpc_id
  sg_description = "SSH Security Group"
  ingress = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH access"
    }
  ]
  egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
}


module "baston-host" {
  source = "./ec2-module"
  instance_name = "baston-host"
  ami = "ami-0e449927258d45bc4" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name = "santosh"
  vpc_security_group_ids = [module.ssh-sg.sg_id]
  subnet_id = module.vpc.public_subnet_ids[0]
  iam_instance_profile_name = aws_iam_instance_profile.instance_profile.name
  associate_public_ip_address = true
  tags = {
    Name        = "baston-host"
    Environment = "dev"
  }
}
