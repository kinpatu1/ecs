variable "cidr_vpc" {}
variable "cidr_public" {}
variable "cidr_private_ecs" {}
variable "cidr_private_rds" {}
variable "route_table_name" {}
variable "subnet_name" {}
variable "igw_name" {}
variable "vpc_name" {}
variable "s3endpoint_name" {}
variable "nat_gateway_name" {}
variable "eip_name" {}
variable "customer_bucket" {}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c"]
}