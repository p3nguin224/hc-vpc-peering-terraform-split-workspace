locals {
  vpc_cidr_split     = split(".", aws_vpc.hc-forntend-vpc.cidr_block)
  subnet_cidr_prefix = "${local.vpc_cidr_split[0]}.${local.vpc_cidr_split[1]}"
}

## Public Subnets ##
resource "aws_subnet" "public_subnets" {
  vpc_id            = aws_vpc.hc-forntend-vpc.id
  enable_dns64      = false
  count             = 3
  cidr_block        = "${local.subnet_cidr_prefix}.${count.index + 1}.0/24"
  availability_zone = element(data.aws_availability_zones.available_az.names, count.index)

  tags = merge(var.based-tags,
    {
      Name = "pub-subnet-${count.index + 1}"
  })
}

## Private Subnets ##
resource "aws_subnet" "private_subnets" {
  vpc_id            = aws_vpc.hc-forntend-vpc.id
  enable_dns64      = false
  count             = 3
  cidr_block        = "${local.subnet_cidr_prefix}.25${count.index + 3}.0/24"
  availability_zone = element(data.aws_availability_zones.available_az.names, count.index)

  tags = merge(var.based-tags,
    {
      Name = "pri-subnet-${count.index + 1}"
  })
}

## Public Route table ##
resource "aws_route_table" "public-routeTable" {
  vpc_id = aws_vpc.hc-forntend-vpc.id

  route {
    cidr_block = var.vpc-cidr
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.based-tags,
    {
      Name = "public rtb"
  })
}

resource "aws_route_table_association" "public-rt-associations" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public-routeTable.id
}


## Private Route table 1 ##
resource "aws_route_table" "private-routeTable1" {
  vpc_id = aws_vpc.hc-forntend-vpc.id

  route {
    cidr_block = var.vpc-cidr
    gateway_id = "local"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = merge(var.based-tags,
    {
      Name = "private rtb 1"
  })
}


## Private Route table 2 and 3 ##
resource "aws_route_table" "private-routeTable-2-3" {
  vpc_id = aws_vpc.hc-forntend-vpc.id
  count  = 2

  route {
    cidr_block = var.vpc-cidr
    gateway_id = "local"
  }

  tags = merge(var.based-tags,
    {
      Name = "private rtb ${count.index + 2}"
  })
}

resource "aws_route_table_association" "private-rt-1-associations" {
  subnet_id      = aws_subnet.private_subnets[0].id
  route_table_id = aws_route_table.private-routeTable1.id
}

resource "aws_route_table_association" "private-rt-2-3-associations" {
  count          = length(aws_route_table.private-routeTable-2-3)
  subnet_id      = aws_subnet.private_subnets[count.index + 1].id
  route_table_id = aws_route_table.private-routeTable-2-3[count.index].id
}

