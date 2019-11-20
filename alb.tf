# alb.tf

resource "aws_alb" "main" {
  name            = "erp-alb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.alb.id]

  # subnet_mapping {
  #   subnet_id     = aws_subnet.public[0].id
  #   allocation_id = "eipalloc-082791d5b3e8c2483"
  # }
}

# Create the ALB target group for ECS
resource "aws_alb_target_group" "app_alb" {
  name        = "app-alb"
  port        = var.app_port  # 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = var.health_check_path
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
  }

}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = "80"    #var.app_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app_alb.id
    type             = "forward"
  }
}
