terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.29"
    }
  }
  backend "local" {}
}

provider "aws" {
  region = var.aws_region
}

# VPC + EKS using official modules
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  enable_nat_gateway = true
  single_nat_gateway = true
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

data "aws_availability_zones" "available" {}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  enable_irsa = true

  eks_managed_node_groups = {
    general = {
      instance_types = [var.node_instance]
      desired_size   = 3
      min_size       = 2
      max_size       = 6
      labels = { role = "general" }
    }

    gpu = {
      instance_types = [var.gpu_instance]
      desired_size   = 0
      min_size       = 0
      max_size       = 6
      capacity_type  = var.enable_spot_gpu ? "SPOT" : "ON_DEMAND"
      taints = [{
        key    = "nvidia.com/gpu"
        value  = "present"
        effect = "NO_SCHEDULE"
      }]
      labels = { role = "gpu" }
    }
  }
}

# ECR registry repo prefix (we still push per-service repos)
resource "aws_ecr_repository" "base" {
  name                 = "${var.ecr_repo_prefix}/placeholder"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = true }
}

output "cluster_name" {
  value = var.cluster_name
}
output "region" {
  value = var.aws_region
}
output "ecr_repo_prefix" {
  value = aws_ecr_repository.base.name
}
