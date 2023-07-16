resource "aws_lb" "yoogaalb" {
  name               = "t101-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.yoogasubnet1.id, aws_subnet.yoogasubnet2.id]
  security_groups = [aws_security_group.yoogasg.id]

  tags = {
    Name = "t101-alb"
  }
}

resource "aws_lb_listener" "yoogahttp" {
  load_balancer_arn = aws_lb.yoogaalb.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found - T101 Study"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "yoogaalbtg" {
  name = "t101-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.yoogavpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 5
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

output "yoogaalb_dns" {
  value       = aws_lb.yoogaalb.dns_name
  description = "The DNS Address of the ALB"
}
