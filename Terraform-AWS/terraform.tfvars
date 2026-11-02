project_name     = "AWS-disaster-recovery-via-IAC"
primary_region   = "ap-south-1"
secondary_region = "ap-southeast-1"

primary_vpc_cidr   = "10.1.0.0/16"
secondary_vpc_cidr = "10.2.0.0/16"
instance_type      = "t3.micro"
environment        = "Production"


primary_availability_zones   = ["ap-south-1a", "ap-south-1b"]
secondary_availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]

primary_public_subnet_cidrs    = ["10.1.0.0/24", "10.1.2.0/24"]
secondary_public_subnet_cidrs  = ["10.2.1.0/24", "10.2.2.0/24"]
primary_private_subnet_cidrs   = ["10.1.22.0/24", "10.1.33.0/24"]
secondary_private_subnet_cidrs = ["10.2.12.0/24", "10.2.13.0/24"]

primary_bucket_name   = "parikshitarer-dr-primary-unique123"
secondary_bucket_name = "parikshitarer-dr-secondary-unique123"