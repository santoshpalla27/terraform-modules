module "vpc" {
  source = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  project_name = "three-tier-project"
  public_subnet = ["10.0.1.0/24", "10.0.3.0/24"]
  availability_zones_public = ["us-east-1a", "us-east-1c"]
  private_subnet = ["10.0.2.0/24" , "10.0.4.0/24" ]
  private_availability_zone = ["us-east-1b", "us-east-1a"]
}
module "iam" {
  source = "./modules/iam"
}
module "ec2" {
  source = "./modules/ec2"
  instance_ami = "ami-05576a079321f21f8"
  instance_type = "t2.medium"
  subnet_id = module.vpc.public_subnet_id[0]
  instance_name = "ansible-host-sonarqube"
  iam_instance_profile = module.iam.instance_profile
  security_group_id = module.vpc.allow_ssh_sg_id
  key_name = "santosh"
}

module "ec2-1" {
  source = "./modules/ec2"
  instance_ami = "ami-05576a079321f21f8"
  instance_type = "t2.large"
  subnet_id = module.vpc.public_subnet_id[1]
  instance_name = "main-instance"
  iam_instance_profile = module.iam.instance_profile
  security_group_id = module.vpc.main_server_sg_id
  key_name = "santosh"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.6"
  cluster_name = "three-tier-project"
  cluster_version = "1.31"

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true 

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_id

  eks_managed_node_groups = {
    nodes = {
      min_size       = 3
      max_size       = 5
      desired_size   = 3
      instance_type = "t2.medium"
      key_name       = "santosh"
    }
  }
}


