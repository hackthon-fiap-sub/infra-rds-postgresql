variable "postgres_identifier" {
  description = "Identifier for the PostgreSQL RDS instance"
  type        = string
}

variable "postgres_database" {
  description = "Name of the PostgreSQL database"
  type        = string
}

variable "postgres_owner" {
  description = "Owner of the PostgreSQL database"
  type        = string
}

variable "postgres_name" {
  description = "Name of the PostgreSQL user"
  type        = string
}

variable "postgres_db_username" {
  description = "Username for PostgreSQL database access"
  type        = string
}

variable "postgres_user_name" {
  description = "Additional PostgreSQL user name"
  type        = string
}

variable "postgres_user_password" {
  description = "Password for PostgreSQL user"
  type        = string
  sensitive   = true
}

variable "postgres_instance_name" {
  description = "Name of the PostgreSQL instance"
  type        = string
}

variable "postgres_db_password" {
  description = "Password for PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "postgres_port" {
  description = "Port for PostgreSQL"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the RDS security group"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for RDS"
  type        = list(string)
}
