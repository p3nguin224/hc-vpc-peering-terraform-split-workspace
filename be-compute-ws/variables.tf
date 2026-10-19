variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "based-tags" {
  description = "tags for all resources"
  type        = map(string)
  default = {
    "environment" = "dev"
    "createdBy"   = "terraform"
  }
}


variable "key-pair-name" {
  description = "Key-pair to login into EC2"
  type        = string
}

variable "instance-type" {
  description = "Instance type of EC2"
  type        = string
  default     = "t3.micro"
}
