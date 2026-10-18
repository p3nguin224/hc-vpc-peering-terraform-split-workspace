output "public_subnets_cidr" {
  value = aws_subnet.public_subnets[*].cidr_block
}


output "private_subnets_cidr" {
  value = aws_subnet.private_subnets[*].cidr_block
}
