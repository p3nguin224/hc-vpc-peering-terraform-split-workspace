
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



data "aws_ami" "ubuntu_24_04" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


data "terraform_remote_state" "be-security-ws" {
  backend = "remote"
  config = {
    organization = "vpc-peering-test"
    workspaces = {
      name = "be-security-ws"
    }
  }
}


data "terraform_remote_state" "be-network-ws" {
  backend = "remote"
  config = {
    organization = "vpc-peering-test"
    workspaces = {
      name = "be-network-ws"
    }
  }
}
