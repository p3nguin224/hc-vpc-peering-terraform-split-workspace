variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-northeast-1"

}

variable "profile" {
  description = "AWS Profile"
  type        = string
}

variable "vpc-name" {
  description = "VPC Name"
  type        = string
}

variable "vpc-cidr" {
  description = "VPC CIDR Range"
  type        = string
}

variable "based-tags" {
  description = "tags for all resources"
  type        = map(string)
  default = {
    "environment" = "dev"
    "createdBy"   = "terraform"
  }
}
