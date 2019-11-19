# ecs.tf

locals {
   database_endpoint     = aws_db_instance.rds.address
   #database_rid          = aws_db_instance.rds.id

   subnet_id            = aws_subnet.private[0].id
   security_group_ids   = "${aws_security_group.alb.id},${aws_security_group.ecs.id},${aws_security_group.rds.id}"
}


resource "aws_ecs_cluster" "app" {
   name = "app-cluster"
}

/* the task definition for the app */
data "template_file" "app_task" {
   template = file("./templates/ecs/app_task.json.tpl")

   vars = {
      #app1_name            = "migration"
      #app2_name            = "app"
      app_name             = "app"
      app_image            = var.app_image
      app_port             = var.app_port
      fargate_cpu          = 512
      fargate_memory       = 1024
      aws_region           = var.aws_region

      #database_url         = "postgres://${var.database_username}:${var.database_password}@${local.database_endpoint}/${var.database_name}"
      database_url         = "postgresql://postgres:postgres@${local.database_endpoint}:5432/${var.database_name}"
      environment          = var.environment
      jwt_secret           = var.jwt_secret
      jwt_time_token       = var.jwt_time_token
      database_name        = var.database_name
      database_username    = "postgres"  ##var.database_username
      database_password    = "postgres"  ##var.database_password
      mail_server          = var.mail_server
      mail_port            = var.mail_port
      mail_username        = var.mail_username
      mail_password        = var.mail_password
      mail_use_tls         = var.mail_use_tls
      mail_use_ssl         = var.mail_use_ssl
      seed_test            = var.seed_test
      log_group            = aws_cloudwatch_log_group.erp_log_group.name
   }     
}

resource "aws_ecs_task_definition" "app" {
   family                   = "app"
   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
   task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
   network_mode             = "awsvpc"
   requires_compatibilities = ["FARGATE"]
   cpu                      = var.fargate_cpu
   memory                   = var.fargate_memory
   container_definitions    = data.template_file.app_task.rendered
}

/* the task definition for the db migration */
data "template_file" "migration_task" {
   template = file("./templates/ecs/migration_task.json.tpl")

   vars = {
      app_name             = "migration"
      app_image            = var.app_image
      aws_region           = var.aws_region
      #database_url         = "postgres://${var.database_username}:${var.database_password}@${local.database_endpoint}/${var.database_name}"
      database_url         = "postgresql://postgres:postgres@${local.database_endpoint}:5432/${var.database_name}"
      environment          = var.environment
      database_username    = "postgres"  ##var.database_username
      database_password    = "postgres"  ##var.database_password
      database_name        = var.database_name
      log_group            = aws_cloudwatch_log_group.erp_log_group.name
   }
}

resource "aws_ecs_task_definition" "migration" {
   family                   = "migration"
   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
   task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
   network_mode             = "awsvpc"
   requires_compatibilities = ["FARGATE"]
   cpu                      = var.fargate_cpu
   memory                   = var.fargate_memory
   container_definitions    = data.template_file.migration_task.rendered
}

# Create the ECS service
resource "aws_ecs_service" "app" {
   name            = "app-service"
   cluster         = aws_ecs_cluster.app.id
   task_definition = aws_ecs_task_definition.app.arn
   desired_count   = var.app_count   #var.multi_az == true ? "2" : "1"
   launch_type     = "FARGATE"

   network_configuration {
      assign_public_ip = true
      security_groups  = [aws_security_group.ecs.id]
      subnets          = aws_subnet.public.*.id      ## Hasura
      #subnets          = aws_subnet.private.*.id    ## Modules
   }

   load_balancer {
      target_group_arn = aws_alb_target_group.app_alb.id
      container_name   = "app"
      container_port   = var.app_port
   }

   depends_on = [
      aws_alb_listener.front_end, 
      aws_iam_role_policy_attachment.ecs_task_execution_role
   ]
}

# Run ECS task for migration
resource "null_resource" "migration" {
   
   provisioner "local-exec" {
      environment = {
         AWS_ACCESS_KEY_ID     = var.aws_access_key_id
         AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
      }
      command = "aws ecs run-task --launch-type FARGATE --cluster ${aws_ecs_cluster.app.name} --task-definition migration --network-configuration 'awsvpcConfiguration={subnets=[${local.subnet_id}],securityGroups=[${local.security_group_ids}]}'"
   }

   depends_on = [
      aws_db_instance.rds,
      aws_ecs_cluster.app,
      aws_iam_role_policy_attachment.ecs_task_execution_role
   ]
}