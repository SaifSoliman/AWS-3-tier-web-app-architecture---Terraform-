
#launch template for ASG
resource "aws_launch_template" "ASGLaunchTemplate" {
  name_prefix   = "ASGLaunchTemplate"
  image_id      = "ami-0427090fd1714168b"
  instance_type = "t2.micro"

  user_data = <<-EOT
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
sudo docker build 
docker run --restart always -e -p 80:80 -d presenttier:v1
  EOT

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ASG-SecurityGroup.id]
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "ASGLaunchTemplate"
    }
  }
}

#Layer 1 AutoScailing Group
resource "aws_autoscaling_group" "WebLayer_asg" {
  launch_template {
    id      = aws_launch_template.ASGLaunchTemplate.id
    version = "$Latest"
  }

  vpc_zone_identifier = [aws_subnet.publicSubnet1.id, aws_subnet.publicSubnet2.id]
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = 2
}



#launch template for ASG APP
resource "aws_launch_template" "ASGLaunchTemplate2" {
  name_prefix   = "ASGLaunchTemplateAPP"
  image_id      = "ami-0427090fd1714168b"
  instance_type = "t2.micro"
  user_data     = <<-EOT
  sudo yum update -y
  sudo yum install docker -y
  sudo service docker start
  sudo systemctl enable docker
  sudo usermod -a -G docker ec2-user
  sudo docker build
  sudo docker run -p 80:80

  EOT


  lifecycle {
    create_before_destroy = true
  }
  network_interfaces {
    device_index    = 0
    security_groups = [aws_security_group.ASG-SecurityGroupAPP.id]
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "ASGLaunchTemplate"
    }
  }
}
#Layer 2 AutoScailing Group
resource "aws_autoscaling_group" "AppLayer_asg" {
  launch_template {
    id      = aws_launch_template.ASGLaunchTemplate2.id
    version = "$Latest"
  }

  vpc_zone_identifier = [aws_subnet.privateSubnet1.id, aws_subnet.privateSubnet2.id]

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = 2
}

