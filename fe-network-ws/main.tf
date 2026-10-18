## VPC ##
resource "aws_vpc" "hc-forntend-vpc" {
  cidr_block       = var.vpc-cidr
  region           = var.region
  instance_tenancy = "default"

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

# resource "aws_internet_gateway_attachment" "igw-attachment" {
#   internet_gateway_id = aws_internet_gateway.igw.id
#   vpc_id              = aws_vpc.hc-forntend-vpc.id
# }


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
