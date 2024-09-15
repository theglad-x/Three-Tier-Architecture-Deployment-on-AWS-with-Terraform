resource "aws_launch_template" "app_lt" {
  name_prefix   = "App-lt"
  image_id      = var.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [var.app_sg]
  key_name = var.key_name
  description = "Launch template for app server"
  user_data = filebase64("userdata-app.sh")

    tags = {
      Name = "App Launch Template"
    }
}


resource "aws_autoscaling_group" "app_asg" {
  name = "App-autoscaling-group"
  vpc_zone_identifier = var.app_private_subnets
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2
  health_check_grace_period = 200
  health_check_type = "ELB"

target_group_arns =[aws_lb_target_group.app_lbtg.arn]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "app-asg-instance"
    propagate_at_launch = true
}

}


resource "aws_autoscaling_attachment" "app_asg_attach" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  lb_target_group_arn    = aws_lb_target_group.app_lbtg.arn
}



resource "aws_sns_topic" "app_sns" {
 name         = "app-asg-sns"
 display_name = "App Autoscaling"
} 


resource "aws_autoscaling_notification" "app_asg_notify" {
 group_names = ["${aws_autoscaling_group.app_asg.name}"]
 topic_arn     = "${aws_sns_topic.app_sns.arn}"
 notifications  = [
   "autoscaling:EC2_INSTANCE_LAUNCH",
   "autoscaling:EC2_INSTANCE_TERMINATE",
   "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
   "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
 ]
}


resource "aws_sns_topic_subscription" "app_email_sub" {
  topic_arn = aws_sns_topic.app_sns.arn
  protocol  = "email"
  endpoint  = var.email
}


 resource "aws_lb" "app_lb" {
    name       = "app-laodbalancing"
    internal           = true
    load_balancer_type = "application"
    security_groups    = [var.app_lb_sg]
    subnets            = var.app_private_subnets

  enable_deletion_protection = false

depends_on = [ 
  aws_autoscaling_group.app_asg
 ]


  tags = {
    Name = "App-elb"
  } 
}


resource "aws_lb_target_group" "app_lbtg" {
  name        = "app-lb-target-group"
  target_type = "instance"
  port        = var.lbtg_port
  protocol    = var.lbtg_protocol
  vpc_id      = var.vpc_id

health_check {
  path = "/"
  interval = 30
  timeout = 10
  healthy_threshold = 2
  unhealthy_threshold = 2
}
lifecycle {
  create_before_destroy = true
}
  tags = {
    Name = "App loadbalancer target group"
  }
}


resource "aws_lb_listener" "applb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_lbtg.arn
  }
}
