locals {

  postgres_identifier    = "rds-selectgearmotors"
  postgres_database      = "selectgearmotorsdb"
  postgres_owner         = "postgres"
  postgres_name          = "postgres"
  postgres_db_username   = "postgres"
  postgres_user_name     = "sevenuser"
  postgres_user_password = "Postgres2019!"
  postgres_instance_name = "rds-selectgearmotors"
  postgres_db_password   = "Postgres2019!"
  postgres_port          = "5432"

}
terraform {
  required_version = ">= 1.1.6"
  required_providers {
    postgresql = { # This line is what needs to change.
      source = "cyrilgdn/postgresql"
      version = "1.22.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

provider "postgresql" {
  host            = aws_db_instance.rds-selectgearmotors.address
  port            = local.postgres_port
  database        = local.postgres_name
  username        = local.postgres_db_username 
  password        = local.postgres_user_password 
  sslmode         = "require"
  connect_timeout = 15
  superuser       = false
  expected_version = aws_db_instance.rds-selectgearmotors.engine_version
}

resource "aws_db_subnet_group" "rdssubnetv1" {
  name       = "rdssubnetv1"
  subnet_ids = ["subnet-03ef2390558a998a9", "subnet-018e6bd3ea3115b87"]
  tags = {
    Name = "rdssubnetv1"
  }
}

resource "aws_security_group" "rdssecurityv1" {
  name        = "rdssecuritygroupv1"
  description = "Example security group for RDS"
  vpc_id      = "vpc-04308bc5185e0f872"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rdssecurity"
  }
}

resource "aws_db_instance" "rds-selectgearmotors" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "16.1"
  instance_class       = "db.r6g.large"
  identifier           = local.postgres_identifier
  username             = local.postgres_db_username
  password             = local.postgres_user_password
  db_subnet_group_name = aws_db_subnet_group.rdssubnetv1.name
  vpc_security_group_ids = [aws_security_group.rdssecurityv1.id]
  skip_final_snapshot  = true
  publicly_accessible  = true
  tags = {
    Name = "rds-selectgearmotors"
  }
}

resource "postgresql_database" "selectgearmotors-database" {
  name              = local.postgres_database
  owner             = local.postgres_owner
  lc_collate        = "en_US.UTF-8"
  connection_limit  = -1 # sem limite. Ajuste conforme necessário
  allow_connections = true
  template          = "template0" # ou "template1", dependendo da sua necessidade
}