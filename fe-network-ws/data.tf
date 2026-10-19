data "aws_availability_zones" "available_az" {
  region = var.region
  state  = "available"
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
