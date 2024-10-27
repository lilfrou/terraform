output "main_vpc_id" {
  value = module.main.vpc_id
}

output "main_vpc_cidr" {
  value = module.main.vpc_cidr_block
}

output "main_vpc_public_cidr" {
  value = module.main.dmz_cidr_block
}

output "main_vpc_private_a_cidr" {
  value = module.main.private_a_cidr_block
}

output "main_vpc_private_b_cidr" {
  value = module.main.private_b_cidr_block
}

output "main_vpc_public_subnet_ids" {
  value = module.main.dmz_subnet_ids
}

output "main_vpc_private_a_subnet_ids" {
  value = module.main.private_a_subnet_ids
}

output "main_vpc_private_b_subnet_ids" {
  value = module.main.private_b_subnet_ids
}

output "main_vpc_security_group_id" {
  value = module.main.vpc_security_group_id
}

output "main_vpc_s3_endpoint_id" {
  value = module.main.vpc_s3_endpoint_id
}

output "main_vpc_dmz_subnet_ids" {
  value = module.main.dmz_subnet_ids
}

output "main_vpc_flow_log_s3_bucket" {
  value = aws_s3_bucket.vpc_log_s3_bucket.arn
}

# mainly used for peering purposes
output "main_route_table_ids" {
  value = concat(
    [module.main.dmz_route_table_id],
    module.main.private_a_route_table_ids,
    module.main.private_b_route_table_ids
  )
}
