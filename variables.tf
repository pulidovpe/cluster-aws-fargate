# variables.tf

variable "aws_account" {
   description = "The AWS account"
   default     = "767167112715"
}

variable "aws_access_key_id" {
   description = "The AWS account"
}
variable "aws_secret_access_key" {
   description = "The AWS secret"
}

variable "aws_region" {
   description = "The AWS region things are created in"
   default     = "us-east-2"
}

variable "environment" {
   description = "The environment"
   default     = "development"
}

variable "vpc_enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false."
  default     = false
}

variable "ecs_task_execution_role_name" {
   description = "ECS task execution role name"
   default = "myEcsTaskExecutionRole"
}

variable "app_image" {
   description = "Docker image to run in the ECS cluster"
   default     = "767167112715.dkr.ecr.us-east-2.amazonaws.com/erp_advance/production:latest"
}

variable "app_port" {
   description = "Port exposed by the docker image to redirect traffic to"
   default     = 5000
}

variable "az_count" {
   description = "Number of AZs to cover in a given region"
   default     = 2
}

variable "app_count" {
   description = "Number of docker containers to run"
   default     = 0
}

variable "multi_az" {
   default     = true
   description = "Muti-az allowed?"
}

variable "health_check_path" {
   default = "/erp/ui"
}

variable "fargate_cpu" {
   description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
   default     = "1024"
}

variable "fargate_memory" {
   description = "Fargate instance memory to provision (in MiB)"
   default     = "2048"
}

variable "additional_db_security_groups" {
  description = "List of Security Group IDs to have access to the RDS instance"
  default = []
}
############################ RDS ############################

variable "allocated_storage" {
   default     = "20"
   description = "The storage size in GB"
}

variable "instance_class" {
   description = "The instance type"
   default     = "db.t2.micro"
}

variable "database_name" {
   description = "The database name"
   default     = "ERP_Advance"
}

variable "database_username" {
   description = "The username of the database"
   default     = "postgres"
}
# variable "database_dev_user" {
#    description = "The username of the database"
#    default     = "app_user"
# }

variable "database_password" {
   description = "The password of the database"
   default     = "postgres"
}

################################## ENV ##################################
variable "jwt_secret" {
   default = "palabrasecreta"
}
variable "jwt_time_token" {
   default = 7200
}

variable "mail_server" {
   default = "smtp.mailtrap.io"
}
variable "mail_port" {
   default = 2525
}
variable "mail_username" {
   default = "81f3d193f78b4b"
}
variable "mail_password" {
   default = "98fa9c9f5ae977"
}
variable "mail_use_tls" {
   default = "True"
}
variable "mail_use_ssl" {
   default = "False"
}
variable "seed_test" {
   default = "False"
}