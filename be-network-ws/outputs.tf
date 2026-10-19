output "be-network_vpc_id" {
  value = aws_vpc.hc-backend-vpc.id
}

output "public_subnets_cidr" {
  value = aws_subnet.public_subnets[*].cidr_block
}

output "public_subnets_id" {
  value = aws_subnet.public_subnets[*].id
}

output "private_routeTables_id" {
  value = aws_route_table.private-routeTables[*].id
}

output "private_subnets_cidr" {
  value = aws_subnet.private_subnets[*].cidr_block
}

output "private_subnets_id" {
  value = aws_subnet.private_subnets[*].id
}
