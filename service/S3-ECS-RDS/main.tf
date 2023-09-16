

module "ecr" {
  ### Module Path
  source = "../../modules/ecr"

  ecr_name = "${var.project}-ecr"
}

module "ecs" {
  ### Module Path
  source = "../../modules/ecs"

  role_arn_for_taskdef   = var.role_arn_for_taskdef
  task_definition_name   = "${var.project}-taskdef"
  container_name         = "${var.project}-container"
  image                  = module.ecr.repository_url
  account                = var.account
  project                = var.project
  ecs_cluster_name       = "${var.project}-cluster"
  ecs_service_name       = "${var.project}-service"
  capacity_provider_name = "${var.project}-capacity_provider"
  auto_scaling_group_arn = module.autoscaling.autoscaling_arn
}

module "autoscaling" {
  ### Module Path
  source = "../../modules/autoscaling"

  launch_template_name       = "${var.project}-launch_template"
  security_group_application = "${var.project}-security_group-application"
  vpc_id                     = var.vpc_id
  key_name                   = var.key_name
  account                    = var.account
  ecs_cluster_name           = module.ecs.ecs_cluster_name
  private_subnet_id_ecs1     = var.private_subnet_id_ecs1
  private_subnet_id_ecs2     = var.private_subnet_id_ecs2
  autoscaling_group_name     = "${var.project}-autoscaling_group"
  ecs_instance_name          = "ECS Instance - ${var.project}"
}
