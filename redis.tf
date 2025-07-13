resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "medusa-redis"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
}
