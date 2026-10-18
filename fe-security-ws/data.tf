# data "tfe_outputs" "fe-network-ws" {
#   organization = "vpc-peering-test"
#   workspace    = "fe-network-ws"
# }

data "terraform_remote_state" "fe-network-ws" {
  backend = "remote"
  config = {
    organization = "vpc-peering-test"
    workspaces = {
      name = "fe-network-ws"
    }
  }
}
