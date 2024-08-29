

# Web LoadBalancer
resource "aws_lb" "WebLB" {
  name               = "web-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http_WebLB.id]
  subnets            = [aws_subnet.publicSubnet1.id, aws_subnet.publicSubnet2.id]

  enable_deletion_protection = false
}

# target group for listener
resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.appVPC.id
  target_type = "instance"
  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
# resource "aws_lb_target_group_attachment" "web-attachment" {
#   target_group_arn = aws_lb_target_group.target_group.arn
#   target_id        = [aws_instance.webServer1.id, aws_instance.webServer2.id]
#   port             = 80
#   count            = 2
# }
# Load balancer listener
resource "aws_lb_listener" "Web_listener" {
  load_balancer_arn = aws_lb.WebLB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}





# Application LoadBalancer
resource "aws_lb" "AppLB" {
  name               = "App-load-balancer"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.AppLb_sg.id]
  subnets            = [aws_subnet.privateSubnet1.id, aws_subnet.privateSubnet2.id]

  enable_deletion_protection = false
}

# target group for listener
resource "aws_lb_target_group" "target_group_AppLayer" {
  name        = "target-group-app-layer"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.appVPC.id
  target_type = "instance"
  health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Load balancer listener
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.AppLB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_AppLayer.arn
  }
}
