provider "aws" {
  region = var.region
}

resource "aws_ecr_repository" "my_app" {
  name = "calculator-app"
}

resource "aws_ecs_cluster" "main" {
  name = "calculator-fargate-cluster"
}

resource "aws_lb" "app_alb" {
  name               = "calculator-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg]
  subnets            = var.public_subnets
}

resource "aws_lb_target_group" "blue" {
  name        = "calculator-blue-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "green" {
  name        = "calculator-green-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Listener initially points to blue (GitHub Actions will switch later)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}


resource "aws_ecs_task_definition" "app" {
  family                   = "calculator-fargate-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_task_exec_role_arn

  container_definitions = jsonencode([
    {
      name      = "calculator-app"
      image     = "${aws_ecr_repository.my_app.repository_url}:${var.image_tag}"
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "blue" {
  name            = "calculator-blue"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = var.public_subnets
    security_groups  = [var.ecs_sg]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = "calculator-app"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.http]
}

resource "aws_ecs_service" "green" {
  name            = "calculator-green"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 0

  network_configuration {
    subnets          = var.public_subnets
    security_groups  = [var.ecs_sg]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.green.arn
    container_name   = "calculator-app"
    container_port   = 80
  }
  
  lifecycle {
    ignore_changes = [desired_count]  
  }

  depends_on = [aws_lb_listener.http]
}
