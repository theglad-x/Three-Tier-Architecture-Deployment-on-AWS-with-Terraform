provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "tf_keypair" {
  key_name   = "tf-keypair"
  public_key = file(var.my_public_key)
}


data "aws_ami" "latest_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.image_name]
  }
}

module "web-tier" {
  source             = "./modules/web-tier"
  image_id           = data.aws_ami.latest_ami.id
  instance_type      = "t2.micro"
  key_name           = "tf-keypair"
  web_public_subnets = module.vpc.web_public_subnets
  email              = "<your-email>"
  web_lb_sg          = module.security-groups.weblbsg_sec_id
  lbtg_port          = 80
  lbtg_protocol      = "HTTP"
  vpc_id             = module.vpc.vpc_id
  web_sg             = module.security-groups.websg_sec_id
  listener_port      = 80
  listener_protocol  = "HTTP"
}


module "app-tier" {
  source              = "./modules/app-tier"
  image_id            = data.aws_ami.latest_ami.id
  instance_type       = "t2.micro"
  key_name            = "tf-keypair"
  app_private_subnets = module.vpc.app_private_subnets
  email               = "<your-email>"
  app_lb_sg           = module.security-groups.applbsg_sec_id
  lbtg_port           = 80
  lbtg_protocol       = "HTTP"
  vpc_id              = module.vpc.vpc_id
  app_sg              = module.security-groups.appsg_sec_id
  listener_port       = 80
  listener_protocol   = "HTTP"
}


module "db-tier" {
  source               = "./modules/db-tier"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "rdsmysql"
  db_password          = var.db_password
  db_username          = var.db_username
  db_identifier        = "db-tier"
  db_storage           = 10
  db_sg                = module.security-groups.db_sec_id
  db_subnet_group_name = module.vpc.db_subnet_group_name[0]
  multi_az             = true
  skip_final_snapshot  = true
}


module "vpc" {
  source            = "./modules/vpc"
  cidr_block        = "10.0.0.0/16"
  web_pub_sub_count = 2
  private_sub_count = 2
  db_subnet_group   = true
  availability_zone = "us-east-1a"
  azs               = 2
}

module "security-groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
  ip     = var.ip
}
