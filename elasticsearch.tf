# ElasticSearch

/*resource "aws_elasticsearch_domain" "default" {
   domain_name = var.es_domain
   elasticsearch_version = var.es_version

   cluster_config {
      instance_type = var.instance_type
   }

   ## availability_zone_count = 3   ## deben ser 3 
   ## zone_awareness_config {
   ##    availability_zone_count = data.aws_availability_zones.available.names[count.index]
   ## }

   vpc_options {
      subnet_ids = [aws_subnet.private.*.id]
      security_group_ids = [
          ##aws_security_group.rds.id,
          aws_security_group.ecs.id
      ]
   }

   ebs_options {
      ebs_enabled = true
      volume_size = 10
   }

   access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": "es:*",
          "Principal": "*",
          "Effect": "Allow",
          "Resource": "arn:aws:es:${var.aws_region}:${var.aws_account}:domain/${var.es_domain}/*"
      }
  ]
}
  CONFIG

   ## snapshot_options {
   ##    automated_snapshot_start_hour = 23
   ## }

   tags {
      Domain = var.es_domain
   }
}*/