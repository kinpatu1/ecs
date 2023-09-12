module "rds" {
  ### Module Path
  source = "../../modules/rds"

  rds_name           = "${var.project}-rds"
  security_group_rds = "${var.project}-security_group-rds"
  vpc_id             = var.vpc_id
  master_password    = var.master_password
  database_name      = var.project
  master_username    = "admin"
  subnet_group       = "${var.project}-subnet_group"
  subnet_public-a_id = var.subnet_public-a_id
  subnet_public-c_id = var.subnet_public-c_id
}

module "s3" {
  ### Module Path
  source = "../../modules/s3"

  s3_bucket_name = "${var.project}-s3-202301111"
}

module "ecr" {
  ### Module Path
  source = "../../modules/ecr"

  ecr_name = "${var.project}-ecr"
}
