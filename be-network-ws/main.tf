## VPC ##
resource "aws_vpc" "hc-backend-vpc" {
  cidr_block           = var.vpc-cidr
  region               = var.region
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = merge(var.based-tags,
    {
      Name = var.vpc-name
  })
}

## Internet Gateway ##
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.hc-backend-vpc.id

  tags = merge(var.based-tags,
    {
      Name = "backend-igw"
  })
}


## NAT GW ##
resource "aws_nat_gateway" "nat-gw" {
  availability_mode = "regional"
  vpc_id            = aws_vpc.hc-backend-vpc.id

  tags = merge(var.based-tags,
    {
      Name = "backend-nat-gw"
  })

  depends_on = [aws_internet_gateway.igw]
}


# resource "aws_vpc_peering_connection_accepter" "frontend-to-backend-peer" {
#   vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
#   auto_accept               = true

#   tags = merge(var.based-tags,
#     {
#       Side = "Accepter"
#   })
# }

