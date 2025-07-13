resource "aws_ecs_cluster" "medusa" {
  name = "medusa-cluster"
}

resource "aws_ecs_task_definition" "server" {
  family                   = "medusa-server"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  network_mode            = "awsvpc"

  container_definitions = jsonencode([{
    name      = "medusa-server"
    image     = var.ecr_image
    portMappings = [{ containerPort = 9000 }]
    environment = [
      { name = "MEDUSA_WORKER_MODE", value = "server" },
      { name = "DISABLE_MEDUSA_ADMIN", value = "false" },
      { name = "REDIS_URL", value = var.redis_url },
      { name = "DATABASE_URL", value = var.database_url },
      { name = "JWT_SECRET", value = var.jwt_secret },
      { name = "COOKIE_SECRET", value = var.cookie_secret }
    ]
  }])
}

resource "aws_ecs_service" "server" {
  name            = "medusa-server"
  cluster         = aws_ecs_cluster.medusa.id
  task_definition = aws_ecs_task_definition.server.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = module.networking.public_subnets
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_tasks.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.server.arn
    container_name   = "medusa-server"
    container_port   = 9000
  }
}
