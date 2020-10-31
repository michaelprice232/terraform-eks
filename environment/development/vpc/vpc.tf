# VPC in Ireland
module "vpc_ireland" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> v2.0"

  name = "mike-${var.environment_name}"
  cidr = var.vpc_cidr

  azs = [
    for num in range(var.az_count):
      data.aws_availability_zones.available.names[num]
  ]

  private_subnets = [
    for num in range(var.az_count):
      cidrsubnet(var.vpc_cidr, 4, num)
  ]

  public_subnets = [
    for num in range(var.az_count, (var.az_count * 2)):
      cidrsubnet(var.vpc_cidr, 4, num)
  ]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  # Required subnet tags by EKS for auto discovery
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.environment_name}-fargate-only"        = "shared"
    "kubernetes.io/cluster/${var.environment_name}-managed-nodegroups"  = "shared"
    "kubernetes.io/role/elb"                                            = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.environment_name}-fargate-only"        = "shared"
    "kubernetes.io/cluster/${var.environment_name}-managed-nodegroups"  = "shared"
    "kubernetes.io/role/internal-elb"                                   = "1"
  }

  tags = {
    name        = "mike-${var.environment_name}"
    Owner       = var.tag_owner
    Environment = var.environment_name
  }
}