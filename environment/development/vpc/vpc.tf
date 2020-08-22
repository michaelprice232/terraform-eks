# VPC in Ireland
module "vpc_ireland" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> v2.0"

  name = var.environment_name
  cidr = var.vpc_cidr

  # todo: split these using terraform functions
  azs             = [data.aws_availability_zones.available.names[0],
                     data.aws_availability_zones.available.names[1],
                     data.aws_availability_zones.available.names[2]]

  private_subnets = [cidrsubnet(var.vpc_cidr, 4, 0),
                     cidrsubnet(var.vpc_cidr, 4, 1),
                     cidrsubnet(var.vpc_cidr, 4, 2)]

  public_subnets = [cidrsubnet(var.vpc_cidr, 4, 3),
                    cidrsubnet(var.vpc_cidr, 4, 4),
                    cidrsubnet(var.vpc_cidr, 4, 5)]

  enable_dns_hostnames = true
  enable_dns_support = true

  enable_nat_gateway = true
  single_nat_gateway = true

  # Required subnet tags by EKS for auto discovery
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.environment_name}" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.environment_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  }

  tags = {
    Owner       = var.tag_owner
    Environment = var.environment_name
  }
}