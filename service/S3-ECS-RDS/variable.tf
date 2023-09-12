variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "project" {
  type    = string
  default = "flow"
}

variable "account" {
  default = "074708073377"
}

variable "master_password" {}

variable "vpc_id" {
  type    = string
  default = "vpc-0f72eaebca3d4cc26"
}

variable "subnet_public-a_id" {
  type    = string
  default = "subnet-075bc52d0608b4468"
}

variable "subnet_public-c_id" {
  type    = string
  default = "subnet-00033c9e52b39f4ac"
}