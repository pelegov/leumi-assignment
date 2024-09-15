
resource "aws_lb" "nlb_test" {
  name               = "nlb-test"
  load_balancer_type = "network"
  internal           = false
  subnets            = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "tg_test_ec2" {
  name        = "tg-test-ec2"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.selected_vpc.id
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  target_group_arn = aws_lb_target_group.tg_test_ec2.arn
  target_id        = aws_instance.test_ec2.id
  port             = 80
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb_test.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_test_ec2.arn
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = data.aws_vpc.selected_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = data.aws_vpc.selected_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}