########################################
# CloudWatch Logs for Monitoring
########################################
resource "aws_cloudwatch_log_group" "prometheus" {
  name              = "/ecs/prometheus"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "grafana" {
  name              = "/ecs/grafana"
  retention_in_days = 7
}

########################################
# Security Group for Monitoring
########################################
resource "aws_security_group" "monitoring_sg" {
  name        = "monitoring-sg"
  vpc_id      = module.vpc.vpc_id
  description = "Allow Grafana and Prometheus"

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Prometheus (optional: restrict later)
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Grafana UI
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################################
# Prometheus Task Definition
########################################
resource "aws_ecs_task_definition" "prometheus" {
  family                   = "prometheus-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name      = "prometheus"
    image     = "prom/prometheus:latest"
    essential = true
    portMappings = [{
      containerPort = 9090
      hostPort      = 9090
      protocol      = "tcp"
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.prometheus.name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "prometheus"
      }
    }
  }])
}

########################################
# Grafana Task Definition
########################################
resource "aws_ecs_task_definition" "grafana" {
  family                   = "grafana-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name      = "grafana"
    image     = "grafana/grafana-oss:latest"
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
      protocol      = "tcp"
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.grafana.name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "grafana"
      }
    }
  }])
}

########################################
# Prometheus ECS Service
########################################
resource "aws_ecs_service" "prometheus" {
  name            = "prometheus-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.prometheus.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = module.vpc.public_subnets
    assign_public_ip = true
    security_groups = [aws_security_group.monitoring_sg.id]
  }
}

########################################
# Grafana ECS Service
########################################
resource "aws_ecs_service" "grafana" {
  name            = "grafana-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.grafana.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = module.vpc.public_subnets
    assign_public_ip = true
    security_groups = [aws_security_group.monitoring_sg.id]
  }
}





########################################
# Outputs
########################################
output "prometheus_url" {
  value = "http://${aws_ecs_service.prometheus.name}.${var.aws_region}.amazonaws.com:9090"
}

output "grafana_url" {
  value = "http://${aws_ecs_service.grafana.name}.${var.aws_region}.amazonaws.com:3000"
}
