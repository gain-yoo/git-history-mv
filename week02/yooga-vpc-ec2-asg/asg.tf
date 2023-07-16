data "aws_ami" "yooga2_amazonlinux2" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

resource "aws_launch_configuration" "yoogalauchconfig" {
  name_prefix     = "t101-lauchconfig-"
  image_id        = data.aws_ami.yooga2_amazonlinux2.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.yoogasg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              wget https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-x86_64
              mv busybox-x86_64 busybox
              chmod +x busybox
              RZAZ=
              IID=
              LIP=
              echo "<h1>RegionAz() : Instance ID() : Private IP() : Web Server</h1>" > index.html
              nohup ./busybox httpd -f -p 80 &
              EOF

  # Required when using a launch configuration with an auto scaling group.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "yoogaasg" {
  name                 = "yoogaasg"
  launch_configuration = aws_launch_configuration.yoogalauchconfig.name
  vpc_zone_identifier  = [aws_subnet.yoogasubnet1.id, aws_subnet.yoogasubnet2.id]
  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "terraform-asg"
    propagate_at_launch = true
  }
}
