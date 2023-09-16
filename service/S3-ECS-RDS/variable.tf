####################
#common
####################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "project" {}
variable "account" {}
variable "vpc_id" {}

####################
#rds
####################

variable "master_password" {}
variable "database_name" {}
variable "private_subnet-a_id" {}
variable "private_subnet-c_id" {}

####################
#autoscaling
####################

variable "key_name" {}

####################
#ecs
####################

variable "role_for_taskdef_arn" {}