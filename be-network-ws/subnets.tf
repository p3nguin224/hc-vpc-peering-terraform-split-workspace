locals {
  vpc_cidr_split     = split(".", aws_vpc.hc-backend-vpc.cidr_block)
  subnet_cidr_prefix = "${local.vpc_cidr_split[0]}.${local.vpc_cidr_split[1]}"
}

## Public Subnets ##
resource "aws_subnet" "public_subnets" {
  count        = 3
  vpc_id       = aws_vpc.hc-backend-vpc.id
  enable_dns64 = false

  cidr_block        = "${local.subnet_cidr_prefix}.${count.index + 1}.0/24"
  availability_zone = element(data.aws_availability_zones.available_az.names, count.index)

  tags = merge(var.based-tags,
    {
      Name = "pub-subnet-${count.index + 1}"
  })
}

## Private Subnets ##
resource "aws_subnet" "private_subnets" {
  count        = 3
  vpc_id       = aws_vpc.hc-backend-vpc.id
  enable_dns64 = false

  cidr_block        = "${local.subnet_cidr_prefix}.25${count.index + 3}.0/24"
  availability_zone = element(data.aws_availability_zones.available_az.names, count.index)

  tags = merge(var.based-tags,
    {
      Name = "pri-subnet-${count.index + 1}"
  })
}

## Public Route table ##
resource "aws_route_table" "public-routeTable" {
  vpc_id = aws_vpc.hc-backend-vpc.id

  tags = merge(var.based-tags,
    {
      Name = "public rtb"
  })
}

resource "aws_route" "pub-igw-route" {
  route_table_id         = aws_route_table.public-routeTable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}



resource "aws_route_table_association" "public-rt-associations" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public-routeTable.id
}


## Private Route tables ##
resource "aws_route_table" "private-routeTables" {
  count  = 3
  vpc_id = aws_vpc.hc-backend-vpc.id

  tags = merge(var.based-tags,
    {
      Name = "private rtb ${count.index + 1}"
  })
}

resource "aws_route" "priv-nat-gw-route" {
  route_table_id         = aws_route_table.private-routeTables[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
}



# route {
#   cidr_block                = data.terraform_remote_state.fe-network-ws.outputs.private_subnets_cidr[count.index + 1]
#   vpc_peering_connection_id = aws_vpc_peering_connection_accepter.frontend-to-backend-peer.id
# }



resource "aws_route_table_association" "private-rt-associations" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private-routeTables[count.index].id
}


