# rds.tf 

/* subnet used by rds */
resource "aws_db_subnet_group" "rds_subnet_group" {
   name        = "${var.environment}-rds-subnet-group"
   description = "RDS subnet group"
   subnet_ids  = aws_subnet.private.*.id   ## Hasura y Modules
   #subnet_ids  = aws_subnet.public.*.id   ## Probando
   tags = {
      Environment = var.environment
   }
}

resource "aws_db_instance" "rds" {
  name                        = var.database_name
  identifier                  = "${var.environment}-database"
  username                    = "postgres"  ##var.database_username
  password                    = "postgres"  ##var.database_password
  port                        = "5432"
  engine                      = "postgres"
  engine_version              = "11"
  instance_class              = var.instance_class
  allocated_storage           = var.allocated_storage
  storage_encrypted           = false
  vpc_security_group_ids      = [aws_security_group.rds.id]
  db_subnet_group_name        = aws_db_subnet_group.rds_subnet_group.id
  parameter_group_name        = "default.postgres11"
  multi_az                    = var.multi_az
  storage_type                = "gp2"
  publicly_accessible         = false  # true  ## Probando
  apply_immediately           = true
  maintenance_window          = "sun:02:00-sun:04:00"
  skip_final_snapshot         = true
  #snapshot_identifier        = "rds-${var.environment}-snapshot"
  #final_snapshot_identifier   = "rds-${var.environment}-snapshot"
  tags = {
    Environment = var.environment
  }
}

# Setup PostgreSQL Provider After RDS Database is Provisioned
# provider "postgresql" {
#     host            = aws_db_instance.rds.address
#     port            = 5432
#     username        = var.database_username
#     password        = var.database_password
#     ##depends_on      = [aws_db_instance.rds]
# }
# # Create App User
# resource "postgresql_role" "application_role" {
#     name                = var.database_dev_user
#     login               = true
#     password            = var.database_password
#     encrypted_password  = true
#     superuser           = true
#     ##depends_on          = [aws_db_instance.rds]
# }
