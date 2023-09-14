module "rds" {
  ### Module Path
  source = "../../modules/rds"

  rds_name            = "${var.project}-rds"
  security_group_rds  = "${var.project}-security_group-rds"
  vpc_id              = var.vpc_id
  master_password     = var.master_password
  database_name       = var.database_name
  master_username     = "admin"
  subnet_group        = "${var.project}-subnet_group"
  subnet_private-a_id = var.subnet_private-a_id
  subnet_private-c_id = var.subnet_private-c_id
}

module "s3" {
  ### Module Path
  source = "../../modules/s3"

  s3_bucket_name = "${var.project}-s3-20230914"
}

module "ecr" {
  ### Module Path
  source = "../../modules/ecr"

  ecr_name = "${var.project}-ecr"
}

module "ecs" {
  ### Module Path
  source = "../../modules/ecs"

  task_definition_name = "${var.project}-taskdef"
  container_name       = "${var.project}-container"
  image                = module.ecr.repository_url
  account              = var.account
  project              = var.project
  ecs_cluster_name     = "${var.project}-cluster"
  ecs_service_name     = "${var.project}-service"
}

module "autoscaling" {
  ### Module Path
  source = "../../modules/autoscaling"

  launch_template_name       = "${var.project}-launch_template"
  security_group_application = "${var.project}-security_group-application"
  vpc_id                     = var.vpc_id
  security_group_ec2         = var.security_group_ec2
  key_name                   = var.key_name
  account                    = var.account
  ecs_cluster_name           = module.ecs.ecs_cluster_name
  subnet_private-a_id = var.subnet_private-a_id
  subnet_private-c_id = var.subnet_private-c_id
}
