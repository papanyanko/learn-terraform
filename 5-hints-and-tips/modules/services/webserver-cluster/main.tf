resource "aws_launch_configuration" "example" {
  image_id = var.ami
  instance_type = var.instance_type
  security_groups = [ aws_security_group.instance.id ]

  user_data = templatefile("${path.module}/user-data.sh", {
    server_port = var.server_port
    server_text = var.server_text
    db_address = data.terraform_remote_state.db.outputs.address
    db_port = data.terraform_remote_state.db.outputs.port
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  name = var.cluster_name

  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier = data.aws_subnets.default.ids
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  target_group_arns = [ aws_lb_target_group.asg.arn ]
  health_check_type = "ELB"

  min_size = var.min_size
  max_size = var.max_size

  tag {
    key = "Name"
    value = "${var.cluster_name}-instance"
    propagate_at_launch = true
  }
}

resource "aws_lb" "example" {
  name = "${var.cluster_name}-alb"
  load_balancer_type = "application"
  subnets = data.aws_subnets.default.ids
  security_groups = [ aws_security_group.alb.id ]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port = local.http_port
  protocol = local.http_protocol

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = 404
    }
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  condition {
    path_pattern {
      values = [ "*" ]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

resource "aws_lb_target_group" "asg" {
  name = "${var.cluster_name}-asg"
  port = var.server_port
  protocol = local.http_protocol
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/"
    protocol = local.http_protocol
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance"
}

resource "aws_security_group_rule" "allow_http_inbound_instance" {
  type = "ingress"
  description = "example ingress"
  security_group_id = aws_security_group.instance.id

  from_port = var.server_port
  to_port = var.server_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
  ipv6_cidr_blocks = [  ]
  prefix_list_ids = [  ]
}

resource "aws_security_group" "alb" {
  name = "${var.cluster_name}-alb"
}

resource "aws_security_group_rule" "allow_http_inbound_alb" {
  type = "ingress"
  description = "alb ingress"
  security_group_id = aws_security_group.alb.id

  from_port = local.http_port
  to_port = local.http_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
  ipv6_cidr_blocks = [  ]
  prefix_list_ids = [  ]
}

resource "aws_security_group_rule" "allow_all_outbound_alb" {
  type = "egress"
  description = "alb egress"
  security_group_id = aws_security_group.alb.id

  from_port = local.any_port
  to_port = local.any_port
  protocol = local.any_protocol
  cidr_blocks = local.all_ips
  ipv6_cidr_blocks = [  ]
  prefix_list_ids = [  ]
}

locals {
  http_protocol = "HTTP"
  http_port = 80
  any_port = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips = ["0.0.0.0/0"]
}