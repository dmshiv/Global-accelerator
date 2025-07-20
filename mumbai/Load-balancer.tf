// 10 creating load balancer with 2 instances in 2 subnets


// create LB ...........1

resource "aws_lb" "create_load_balancer" {
  name               = "mumbai-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.create_security_group.id]
  subnets            = aws_subnet.create_subnet[*].id # Use all subnets created

  enable_deletion_protection = false

  tags = {
    Name = "mumbai-lb"
  }
}



// create a TG and throw instance in it ...............2

// 11 creating target group for load balancer with 2 instances in 2 subnets

resource "aws_lb_target_group" "create_target_group" {
  name     = "mumbai-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.create_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "mumbai-tg"
  }

}
// 12 registering only public instances to target group

// 12 registering only public instances to target group

resource "aws_lb_target_group_attachment" "create_target_group_attachment" {
  count = length(var.gives_cidr_to_subnets)

  target_group_arn = aws_lb_target_group.create_target_group.arn
  target_id        = aws_instance.create_instance[count.index].id
  port             = 80 # Port on which the instances are listening

  depends_on = [aws_instance.create_instance] // Ensure instances are created before attaching to target group
}



// now atach thay TG to the load balancer ...............3

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.create_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.create_target_group.arn
  }

  depends_on = [
    aws_lb_target_group.create_target_group
  ]
}

