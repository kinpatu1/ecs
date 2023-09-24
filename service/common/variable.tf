####################
#common
####################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "project" {
  type    = string
  default = ""
}

####################
#ec2
####################

variable "key_name" {
  type    = string
  default = ""
}

####################
#vpc
####################

variable "customer_bucket" {
  type    = string
  default = ""
}

####################
#rds
####################

variable "master_password" {}
variable "database_name" {
  type    = string
  default = ""
}

####################
#secretsmanager
####################

variable "slack_notification" {
  type    = string
  default = ""
}