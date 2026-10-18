variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "based-tags" {
  description = "tags for all resources"
  type        = map(string)
  default = {
    "environment" = "dev"
    "createdBy"   = "terraform"
  }
}


variable "management-ip" {
  description = "IP address which will allow for SSH and Ping"
  type        = string
}


