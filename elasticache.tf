# ElastiCache

# resource "aws_elasticache_subnet_group" "default" {
#    name       = "production-cache-subnet"
#    subnet_ids = ["${aws_subnet.private.*.id}"]

# }

# resource "aws_elasticache_replication_group" "default" {
#    replication_group_id          = "redis-cluster"
#    replication_group_description = "Redis cluster for Hashicorp ElastiCache"

#    node_type                  = "cache.t2.micro"
#    port                       = 6379
#    parameter_group_name       = aws_elasticache_parameter_group.default.name

#    engine_version             = var.engine_version

#    snapshot_retention_limit   = var.retention_limit
#    snapshot_window            = "00:00-05:00"

#    subnet_group_name          = aws_elasticache_subnet_group.default.name
#    automatic_failover_enabled = true

#    cluster_mode {
#       replicas_per_node_group  = var.replicas_per_node
#       num_node_groups          = var.node_groups
#    }
# }

# resource "aws_elasticache_parameter_group" "default" {
#    name   = "cache-params"
#    family = "redis5.0"

#    parameter {
#       name  = "cluster-enabled"
#       value = "yes"
#    }
# }
