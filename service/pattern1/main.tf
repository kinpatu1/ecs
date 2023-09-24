module "ecr" {
  ### Module Path
  source = "../../modules/ecr"

  ecr_name = "${var.project}-ecr-${var.env}"
}

module "ecs-fargate" {
  ### Module Path
  source = "../../modules/ecs-fargate"

  ecs_cluster_name           = "${var.project}-cluster-${var.env}"
  task_definition_name       = "${var.project}-taskdef-${var.env}"
  role_arn_for_taskdef       = var.role_arn_for_taskdef
  container_name             = "${var.project}-container-${var.env}"
  image                      = module.ecr.repository_url
  execute_type               = var.execute_type
  customer_bucket            = var.customer_bucket
  project                    = var.project
  security_group_application = "${var.project}-security_group-application-${var.env}"
  vpc_id                     = var.vpc_id
  security_group_gateway     = var.security_group_gateway
}

module "lambda" {
  ### Module Path
  source = "../../modules/lambda"

  function_name            = "${var.project}-lambda-${var.env}"
  CONTAINER_NAME           = var.CONTAINER_NAME
  CRUD_FOR_ECS_SECRET_NAME = "${var.project}-secret_manager_lambda-${var.env}"
  CRUSTER_NAME             = var.CRUSTER_NAME
  SG_NAME                  = var.SG_NAME
  SUBNET_1                 = var.SUBNET_1
  SUBNET_2                 = var.SUBNET_2
  TASK_DEFINITION          = var.TASK_DEFINITION
  subnet_lambda1           = var.private_subnet_id_ecs1
  subnet_lambda2           = var.private_subnet_id_ecs2
  security_group           = module.ecs-fargate.security_group_application_id
  role_name_lambda_exec    = "${var.project}-lambda-${var.env}"
  lambda_policy_name       = "${var.project}-lambda-${var.env}"
}

module "secretsmanager" {
  ### Module Path
  source = "../../modules/secretsmanager_lambda"

  secretsmanager_name = "${var.project}-secret_manager_lambda-${var.env}"
  task_def            = "${var.project}-taskdef-${var.env}"
  subnet_1            = var.private_subnet_id_ecs1
  subnet_2            = var.private_subnet_id_ecs2
  sg_name             = module.ecs-fargate.security_group_application_id
  container_name      = "${var.project}-container-${var.env}"
  cruster_name        = "${var.project}-cluster-${var.env}"
}