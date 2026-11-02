# ==========================================
# PRIMARY NETWORKING - MUMBAI
# ==========================================

module "primary_networking" {
  source = "./modules/networking"

  providers = {
    aws = aws.primary
  }

  project_name         = "${var.project_name}-primary"
  vpc_cidr             = var.primary_vpc_cidr
  public_subnet_cidrs  = var.primary_public_subnet_cidrs
  private_subnet_cidrs = var.primary_private_subnet_cidrs
  availability_zones   = var.primary_availability_zones
  environment          = var.environment
}


# ==========================================
# SECONDARY NETWORKING - SINGAPORE
# ==========================================

module "secondary_networking" {
  source = "./modules/networking"

  providers = {
    aws = aws.secondary
  }

  project_name         = "${var.project_name}-secondary"
  vpc_cidr             = var.secondary_vpc_cidr
  public_subnet_cidrs  = var.secondary_public_subnet_cidrs
  private_subnet_cidrs = var.secondary_private_subnet_cidrs
  availability_zones   = var.secondary_availability_zones
  environment          = var.environment
}


# ==========================================
# PRIMARY SECURITY
# ==========================================

module "primary_security" {
  source = "./modules/security"

  providers = {
    aws = aws.primary
  }

  project_name = "${var.project_name}-primary"
  vpc_id       = module.primary_networking.vpc_id
  environement = var.environment

}


# ==========================================
# SECONDARY SECURITY
# ==========================================

module "secondary_security" {
  source = "./modules/security"

  providers = {
    aws = aws.secondary
  }

  project_name = "${var.project_name}-secondary"
  vpc_id       = module.secondary_networking.vpc_id
  environement = var.environment
}


# ==========================================
# PRIMARY EC2
# ==========================================

module "primary_ec2" {
  source = "./modules/ec2"

  providers = {
    aws = aws.primary
  }

  project_name         = "${var.project_name}-primary"
  instance_type        = var.instance_type
  subnet_id            = module.primary_networking.private_subnet_ids[0]
  security_group_id    = module.primary_security.ec2_security_group_id
  iam_instance_profile = null
  environment          = var.environment
}
# ==========================================
# SECONDARY EC2
# ==========================================

module "secondary_ec2" {
  source = "./modules/ec2"

  providers = {
    aws = aws.secondary
  }

  project_name         = "${var.project_name}-secondary"
  instance_type        = var.instance_type
  subnet_id            = module.secondary_networking.private_subnet_ids[0]
  security_group_id    = module.secondary_security.ec2_security_group_id
  iam_instance_profile = null
  environment          = var.environment
}

# ==========================================
# PRIMARY ALB
# ==========================================

module "primary_alb" {
  source = "./modules/alb"

  providers = {
    aws = aws.primary
  }

  project_name          = "${var.project_name}-primary"
  vpc_id                = module.primary_networking.vpc_id
  public_subnet_ids     = module.primary_networking.public_subnet_ids
  alb_security_group_id = module.primary_security.alb_security_group_id
  ec2_instance_id       = module.primary_ec2.instance_id
  environment           = var.environment
}


# ==========================================
# SECONDARY ALB
# ==========================================

module "secondary_alb" {
  source = "./modules/alb"

  providers = {
    aws = aws.secondary
  }

  project_name          = "${var.project_name}-secondary"
  vpc_id                = module.secondary_networking.vpc_id
  public_subnet_ids     = module.secondary_networking.public_subnet_ids
  alb_security_group_id = module.secondary_security.alb_security_group_id
  ec2_instance_id       = module.secondary_ec2.instance_id
  environment           = var.environment
}


# ==========================================
# S3 CROSS-REGION REPLICATION
# ==========================================
variable "primary_bucket_name" {
  type = string
}
variable "secondary_bucket_name" {
  type = string
}

module "s3_replication" {
  source = "./modules/s3-replication"

  providers = {
    aws.primary   = aws.primary
    aws.secondary = aws.secondary
  }

  project_name          = var.project_name
  primary_bucket_name   = var.primary_bucket_name
  secondary_bucket_name = var.secondary_bucket_name
  environment           = var.environment
}


# ==========================================
# PRIMARY MONITORING
# ==========================================

module "primary_monitoring" {
  source = "./modules/monitoring"

  providers = {
    aws = aws.primary
  }

  project_name = "${var.project_name}-primary"
  instance_id  = module.primary_ec2.instance_id
  environment  = var.environment
}


# ==========================================
# SECONDARY MONITORING
# ==========================================

module "secondary_monitoring" {
  source = "./modules/monitoring"

  providers = {
    aws = aws.secondary
  }

  project_name = "${var.project_name}-secondary"
  instance_id  = module.secondary_ec2.instance_id
  environment  = var.environment
}


# ==========================================
# DISASTER RECOVERY AUTOMATION
# ==========================================

module "dr_automation" {
  source = "./modules/dr-automation"

  providers = {
    aws = aws.primary
  }

  project_name          = var.project_name
  primary_alarm_arn     = module.primary_monitoring.status_check_alarm_arn
  secondary_alarm_arn   = module.secondary_monitoring.status_check_alarm_arn
  primary_instance_id   = module.primary_ec2.instance_id
  secondary_instance_id = module.secondary_ec2.instance_id
  environment           = var.environment
}