# AWS Multi-Region VPC Peering with Terraform

This repository provides Terraform configurations to establish cross-region VPC Peering between two distinct AWS regions:
- **Frontend (FE) VPC**: `ap-northeast-1` (Tokyo)
- **Backend (BE) VPC**: `ap-southeast-1` (Singapore)

---

## Architecture Diagram

You can view the detailed architecture layout here:
[Excalidraw Architecture Diagram](https://excalidraw.com/#json=a3-JeUEvRU-qFKFR8PuD3,JNt4zHNjsKbYT0uHiykuYA)

---

## Workspace Breakdown

### 1. Network Workspace
Contains core network infrastructure:
- Virtual Private Cloud (VPC)
- Public and Private Subnets
- Internet Gateways (IGW) & NAT Gateways
- VPC Peering Connections
- Route Tables and Routing Entries

### 2. Security Workspace
Contains network access control configurations:
- Security Groups
- Ingress and Egress Rules (including cross-region rules)

### 3. Compute Workspace
Contains compute instances and access keys:
- Public and Private EC2 Instances
- EC2 Key Pairs

---

## Deployment Order

Because of resource dependencies across regions, you must run `terraform apply` in the following strict sequential order:

1. **BE Network** - Deploy Backend VPC and subnets
2. **FE Network** - Deploy Frontend VPC and establish Peering to BE
3. **BE Security** - Deploy Backend Security Groups
4. **FE Security** - Deploy Frontend Security Groups with reference to BE
5. **BE Compute** - Deploy Backend Instances and retrieve SSH key
6. **FE Compute** - Deploy Frontend Instances
