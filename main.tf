module "cloudwatch_agent" {
  source = "git::https://github.com/cloudposse/terraform-aws-cloudwatch-agent?ref=master"

  name = "cloudwatch_agent"
}

resource "aws_launch_configuration" "multipart" {
  name_prefix          = "cloudwatch_agent"
  image_id             = "${data.aws_ami.ecs_optimized.id}"
  iam_instance_profile = "${aws_iam_instance_profile.cloudwatch_agent.name}"
  instance_type        = "t2.micro"
  user_data_base64     = "${module.cloudwatch_agent.user_data}"
  security_groups      = ["${aws_security_group.ecs.id}"]
  key_name             = "${var.ssh_key_pair}"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "ecs_optimized" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-*"]
  }

  owners = [
    "amazon",
  ]
}