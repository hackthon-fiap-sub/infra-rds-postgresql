locals {
  postgres_identifier    = var.postgres_identifier
  postgres_database      = var.postgres_database
  postgres_owner         = var.postgres_owner
  postgres_name          = var.postgres_name
  postgres_db_username   = var.postgres_db_username
  postgres_user_name     = var.postgres_user_name
  postgres_user_password = var.postgres_user_password
  postgres_instance_name = var.postgres_instance_name
  postgres_db_password   = var.postgres_db_password
  postgres_port          = var.postgres_port
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "rdssecurityv1" {
  vpc_id = var.vpc_id
  # restante do código permanece o mesmo
}

resource "aws_db_subnet_group" "rdssubnetv1" {
  subnet_ids = var.subnet_ids
  # restante do código permanece o mesmo
}
