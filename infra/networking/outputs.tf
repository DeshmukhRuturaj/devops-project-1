output "dev_proj_1_vpc_id" {
  value = aws_vpc.dev_proj_1_vpc_eu_central_1.id
}

output "dev_proj_1_public_subnets" {
  value = aws_subnet.dev_proj_1_public_subnets[*].id
}

output "dev_proj_1_private_subnets" {
  value = aws_subnet.dev_proj_1_private_subnets[*].id
}

output "public_subnet_cidr_block" {
  value = aws_subnet.dev_proj_1_public_subnets[*].cidr_block
}

output "private_subnet_cidr_block" {
  value = aws_subnet.dev_proj_1_private_subnets[*].cidr_block
}

output "internet_gateway_id" {
  value = aws_internet_gateway.dev_proj_1_public_internet_gateway.id
}

output "public_route_table_id" {
  value = aws_route_table.dev_proj_1_public_route_table.id
}

output "private_route_table_id" {
  value = aws_route_table.dev_proj_1_private_subnets.id
}