data "aws_availability_zones" "available_az" {
  region = var.region
  state  = "available"
}
