## Public Security Group ##
resource "aws_security_group" "public-sg" {
  name        = "pub-sgp-01"
  description = "Allow SSH and Ping only to Management IP"
  vpc_id      = data.terraform_remote_state.fe-network-ws.outputs.fe-network_vpc_id

  tags = merge(var.based-tags,
    {
      Name = "pub-sgp-01"
  })
}


resource "aws_vpc_security_group_ingress_rule" "public-sg-ssh" {
  security_group_id = aws_security_group.public-sg.id
  cidr_ipv4         = var.management-ip
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "public-sg-ping" {
  security_group_id = aws_security_group.public-sg.id
  cidr_ipv4         = var.management-ip
  from_port         = 8
  ip_protocol       = "icmp"
  to_port           = 0
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.public-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


##################################################

## Private Security Groups ##
resource "aws_security_group" "priv-sgs" {
  count       = 3
  name        = "pri-sgp-0${count.index + 1}"
  description = "Allow SSH and Ping only to Management IP"
  vpc_id      = data.terraform_remote_state.fe-network-ws.outputs.fe-network_vpc_id

  tags = merge(var.based-tags,
    {
      Name = "pri-sgp-0${count.index + 1}"
  })
}


## pri-sgp-01 - INBOUND ##
resource "aws_vpc_security_group_ingress_rule" "pri-sgp-01-ssh" {
  security_group_id            = aws_security_group.priv-sgs[0].id
  referenced_security_group_id = aws_security_group.public-sg.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}
resource "aws_vpc_security_group_ingress_rule" "pri-sgp-01-ping" {
  security_group_id            = aws_security_group.priv-sgs[0].id
  referenced_security_group_id = aws_security_group.public-sg.id
  from_port                    = 8
  ip_protocol                  = "icmp"
  to_port                      = 0
}

## pri-sgp-01 - OUTBOUND ##
resource "aws_vpc_security_group_egress_rule" "pri-sgp-01-all" {
  security_group_id = aws_security_group.priv-sgs[0].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}





## pri-sgp-02 - INBOUND ##
resource "aws_vpc_security_group_ingress_rule" "pri-sgp-02-ssh-from-pri-sgp-01" {
  security_group_id            = aws_security_group.priv-sgs[1].id
  referenced_security_group_id = aws_security_group.priv-sgs[0].id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}
resource "aws_vpc_security_group_ingress_rule" "pri-sgp-02-ping-from-pri-sgp-01" {
  security_group_id            = aws_security_group.priv-sgs[1].id
  referenced_security_group_id = aws_security_group.priv-sgs[0].id
  from_port                    = 8
  ip_protocol                  = "icmp"
  to_port                      = 0
}

resource "aws_vpc_security_group_ingress_rule" "pri-sgp-02-ssh-from-be-pri-sgp-02" {
  security_group_id = aws_security_group.priv-sgs[1].id
  cidr_ipv4         = data.terraform_remote_state.be-network-ws.outputs.private_subnets_cidr[1]
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "pri-sgp-02-ping-from-be-pri-sgp-02" {
  security_group_id = aws_security_group.priv-sgs[1].id
  cidr_ipv4         = data.terraform_remote_state.be-network-ws.outputs.private_subnets_cidr[1]
  from_port         = 8
  ip_protocol       = "icmp"
  to_port           = 0
}


## pri-sgp-02 - OUTBOUND ##
resource "aws_vpc_security_group_egress_rule" "pri-sgp-02-ssh-to-be-pri-sgp-02" {
  security_group_id = aws_security_group.priv-sgs[1].id
  cidr_ipv4         = data.terraform_remote_state.be-network-ws.outputs.private_subnets_cidr[1]
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_egress_rule" "pri-sgp-02-ping-to-be-pri-sgp-02" {
  security_group_id = aws_security_group.priv-sgs[1].id
  cidr_ipv4         = data.terraform_remote_state.be-network-ws.outputs.private_subnets_cidr[1]
  from_port         = 8
  ip_protocol       = "icmp"
  to_port           = 0
}




## pri-sgp-03 - INBOUND ##
resource "aws_vpc_security_group_ingress_rule" "pri-sgp-03-ssh-from-pri-sgp-01" {
  security_group_id            = aws_security_group.priv-sgs[2].id
  referenced_security_group_id = aws_security_group.priv-sgs[0].id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}
resource "aws_vpc_security_group_ingress_rule" "pri-sgp-03-ping-from-pri-sgp-01" {
  security_group_id            = aws_security_group.priv-sgs[2].id
  referenced_security_group_id = aws_security_group.priv-sgs[0].id
  from_port                    = 8
  ip_protocol                  = "icmp"
  to_port                      = 0
}
resource "aws_vpc_security_group_ingress_rule" "pri-sgp-03-ssh-from-be-pri-sgp-03" {
  security_group_id = aws_security_group.priv-sgs[2].id
  cidr_ipv4         = data.terraform_remote_state.be-network-ws.outputs.private_subnets_cidr[2]
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "pri-sgp-03-ping-from-be-pri-sgp-03" {
  security_group_id = aws_security_group.priv-sgs[2].id
  cidr_ipv4         = data.terraform_remote_state.be-network-ws.outputs.private_subnets_cidr[2]
  from_port         = 8
  ip_protocol       = "icmp"
  to_port           = 0
}


## pri-sgp-03 - OUTBOUND ##
resource "aws_vpc_security_group_egress_rule" "pri-sgp-02-ssh-to-be-pri-sgp-03" {
  security_group_id = aws_security_group.priv-sgs[2].id
  cidr_ipv4         = data.terraform_remote_state.be-network-ws.outputs.private_subnets_cidr[2]
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_egress_rule" "pri-sgp-02-ping-to-be-pri-sgp-03" {
  security_group_id = aws_security_group.priv-sgs[2].id
  cidr_ipv4         = data.terraform_remote_state.be-network-ws.outputs.private_subnets_cidr[2]
  from_port         = 8
  ip_protocol       = "icmp"
  to_port           = 0
}




##################################################
## Backend cross

## pri-sgp-02 - INBOUND ##
resource "aws_vpc_security_group_ingress_rule" "be-pri-sgp-02-ssh-from-fe-pri-sgp-02" {
  provider          = aws.backend
  security_group_id = data.terraform_remote_state.be-security-ws.outputs.private-sgs-id-list[1]
  cidr_ipv4         = data.terraform_remote_state.fe-network-ws.outputs.private_subnets_cidr[1]
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "be-pri-sgp-02-ping-from-fe-pri-sgp-02" {
  provider          = aws.backend
  security_group_id = data.terraform_remote_state.be-security-ws.outputs.private-sgs-id-list[1]
  cidr_ipv4         = data.terraform_remote_state.fe-network-ws.outputs.private_subnets_cidr[1]
  from_port         = 8
  ip_protocol       = "icmp"
  to_port           = 0
}

## pri-sgp-02 - OUTBOUND ##
resource "aws_vpc_security_group_egress_rule" "be-pri-sgp-02-ssh-to-be-pri-sgp-02" {
  provider          = aws.backend
  security_group_id = data.terraform_remote_state.be-security-ws.outputs.private-sgs-id-list[1]
  cidr_ipv4         = data.terraform_remote_state.fe-network-ws.outputs.private_subnets_cidr[1]
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_egress_rule" "be-pri-sgp-02-ping-to-be-pri-sgp-02" {
  provider          = aws.backend
  security_group_id = data.terraform_remote_state.be-security-ws.outputs.private-sgs-id-list[1]
  cidr_ipv4         = data.terraform_remote_state.fe-network-ws.outputs.private_subnets_cidr[1]
  from_port         = 8
  ip_protocol       = "icmp"
  to_port           = 0
}



## pri-sgp-03 - INBOUND ##
resource "aws_vpc_security_group_ingress_rule" "be-pri-sgp-03-ssh-from-fe-pri-sgp-03" {
  provider          = aws.backend
  security_group_id = data.terraform_remote_state.be-security-ws.outputs.private-sgs-id-list[2]
  cidr_ipv4         = data.terraform_remote_state.fe-network-ws.outputs.private_subnets_cidr[2]
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "be-pri-sgp-03-ping-from-fe-pri-sgp-03" {
  provider          = aws.backend
  security_group_id = data.terraform_remote_state.be-security-ws.outputs.private-sgs-id-list[2]
  cidr_ipv4         = data.terraform_remote_state.fe-network-ws.outputs.private_subnets_cidr[2]
  from_port         = 8
  ip_protocol       = "icmp"
  to_port           = 0
}

## pri-sgp-03 - OUTBOUND ##
resource "aws_vpc_security_group_egress_rule" "be-pri-sgp-03-ssh-to-be-pri-sgp-03" {
  provider          = aws.backend
  security_group_id = data.terraform_remote_state.be-security-ws.outputs.private-sgs-id-list[2]
  cidr_ipv4         = data.terraform_remote_state.fe-network-ws.outputs.private_subnets_cidr[2]
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_egress_rule" "be-pri-sgp-03-ping-to-be-pri-sgp-03" {
  provider          = aws.backend
  security_group_id = data.terraform_remote_state.be-security-ws.outputs.private-sgs-id-list[2]
  cidr_ipv4         = data.terraform_remote_state.fe-network-ws.outputs.private_subnets_cidr[2]
  from_port         = 8
  ip_protocol       = "icmp"
  to_port           = 0
}
