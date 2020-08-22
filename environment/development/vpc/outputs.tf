output "vpc_cidr" {
  value = module.vpc_ireland.vpc_cidr_block
}

output "vpc_id" {
  value = module.vpc_ireland.vpc_id
}

output "private_subnets" {
  value = module.vpc_ireland.private_subnets
}

output "public_subnets" {
  value = module.vpc_ireland.public_subnets
}