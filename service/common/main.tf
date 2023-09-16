module "vpc" {
  ### Module Path
  source = "../../modules/vpc"

  cidr_vpc = "10.0.0.0/16"
  cidr_public = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
  cidr_private_ecs = [
    "10.0.10.0/24",
    "10.0.20.0/24"
  ]
  cidr_private_rds = [
    "10.0.100.0/24",
    "10.0.200.0/24"
  ]
  route_table_name = "${var.project}-rtb"
  subnet_name      = "${var.project}-subnet"
  igw_name         = "${var.project}-igw"
  vpc_name         = "${var.project}-vpc"
  s3endpoint_name  = "${var.project}-s3endpoint"
  public_subnet_id = module.vpc.public_subnet_id_1
  nat_gateway_name = "${var.project}-nat_gateway"
  eip_name         = "${var.project}-eip_nat_gateway"
}

module "ec2" {
  ### Module Path
  source = "../../modules/ec2"

  key_name               = var.key_name
  ebs_name               = "${var.project}-ebs"
  ec2_name               = "${var.project}-ec2-gateway"
  security_group_gateway = "${var.project}-security_group-gateway"
  vpc_id                 = module.vpc.vpc_id
  subnet_id              = module.vpc.public_subnet_id_1
}

####################
#別アカウントのS3バケットポリシーにIAM role名を登録しているので、名前の変更は禁止
####################

module "iam" {
  ### Module Path
  source = "../../modules/iam"

  role_name_ecs_taskdef   = "${var.project}-taskdef_role"
  policy_name_ecs_taskdef = "${var.project}-taskdef_policy"
}