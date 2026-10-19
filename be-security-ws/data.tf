
data "terraform_remote_state" "be-network-ws" {
  backend = "remote"
  config = {
    organization = "vpc-peering-test"
    workspaces = {
      name = "be-network-ws"
    }
  }
}
