## VPC ##
resource "aws_vpc" "hc-forntend-vpc" {
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
  vpc_id = aws_vpc.hc-forntend-vpc.id

  tags = merge(var.based-tags,
    {
      Name = "frontend-igw"
  })
}



## NAT GW ##
resource "aws_nat_gateway" "nat-gw" {
  availability_mode = "regional"
  vpc_id            = aws_vpc.hc-forntend-vpc.id

  tags = merge(var.based-tags,
    {
      Name = "frontend-nat-gw"
  })

  depends_on = [aws_internet_gateway.igw]
}

