terraform {
  required_version = "1.16.6"
  cloud {
    organization = "vpc-peering-test"
    workspaces {
      name = "be-network-ws"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}



# Configure the AWS Provider
provider "aws" {
  region = var.region
}

