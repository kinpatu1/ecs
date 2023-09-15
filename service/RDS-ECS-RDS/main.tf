module "vpc" {
  ### Module Path
  source = "../modules/vpc"


  cidr_vpc = "10.0.0.0/16"
  cidr_public = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
  cidr_private = [
    "10.0.10.0/24",
    "10.0.20.0/24"
  ]
  route_table_name = "${var.project}-rtb"
  subnet_name      = "${var.project}-subnet"
  igw_name         = "${var.project}-igw"
  vpc_name         = "${var.project}-vpc"
  s3endpoint_name  = "${var.project}-s3endpoint"
}

module "ec2" {
  ### Module Path
  source = "../modules/ec2"

  key_name           = "miki"
  ebs_name           = "${var.project}-ebs"
  ec2_name           = "${var.project}-ec2"
  security_group_ec2 = "${var.project}-security_group-ec2"
  vpc_id             = module.vpc.vpc_id
  subnet_id          = module.vpc.subnet_public_id_1
}

module "rds" {
  ### Module Path
  source = "../modules/rds"

  rds_name           = "${var.project}-rds"
  security_group_rds = "${var.project}-security_group-rds"
  vpc_id             = module.vpc.vpc_id
  master_password    = var.master_password
  database_name      = var.project
  master_username    = "admin"
  subnet_group       = "${var.project}-subnet_group"
  subnet_public-a_id = module.vpc.subnet_public_id_1
  subnet_public-c_id = module.vpc.subnet_public_id_2
}

module "s3" {
  ### Module Path
  source = "../modules/s3"

  s3_bucket_name = "${var.project}-s3-202301111"
}