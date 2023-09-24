####################
#common
####################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "project" {
  type    = string
  default = ""
}
variable "env" {
  type    = string
  default = ""
}

####################
#ecs
####################

variable "security_group_gateway" {
  type    = string
  default = ""
}

variable "role_arn_for_taskdef" {
  type    = string
  default = ""
}

variable "customer_bucket" {
  type    = string
  default = ""
}

variable "execute_type" {
  type    = string
  default = "1"
}

variable "vpc_id" {
  type    = string
  default = ""
}

####################
#lambda
####################
variable "CONTAINER_NAME" {
  type    = string
  default = ""
}
variable "CRUD_FOR_ECS_SECRET_NAME" {
  type    = string
  default = ""
}
variable "CRUSTER_NAME" {
  type    = string
  default = ""
}
variable "SG_NAME" {
  type    = string
  default = ""
}
variable "SUBNET_1" {
  type    = string
  default = ""
}
variable "SUBNET_2" {
  type    = string
  default = ""
}
variable "TASK_DEFINITION" {
  type    = string
  default = ""
}
variable "account" {
  type    = string
  default = ""
}

variable "private_subnet_id_ecs1" {
  type    = string
  default = ""
}

variable "private_subnet_id_ecs2" {
  type    = string
  default = ""
}