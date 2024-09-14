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

terraform {
  required_version = ">= 1.1.6"
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.22.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
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

# Use an existing VPC and subnet group, no need to create a new one
# If you need to use an existing security group, you can reference its ID directly.

resource "aws_security_group" "rdssecurityv1" {
  name        = "rdssecuritygroupv1"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id # Existing VPC ID

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust for security as needed
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
  db_subnet_group_name = var.db_subnet_group_name # Use existing subnet group
  vpc_security_group_ids = [aws_security_group.rdssecurityv1.id] # Or an existing SG ID
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
  connection_limit  = -1
  allow_connections = true
  template          = "template0"

  # Ensure this resource waits for the DB instance to be created
  depends_on = [aws_db_instance.rds-selectgearmotors]
}
