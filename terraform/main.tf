provider "aws" {
  
}

resource "aws_iam_role" "ec2_role" {
  name = "jenkins-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_role_policy" "eks_inline" {
  name = "eks-inline-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_security_group" "jenkins_sg" {
  name = "jenkins-sg"
  description = "Allow Jenkins UI Access"

  ingress  {
    description = "Allow port 8080"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress  {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "jenkins-server" {
  ami="ami-025ca978d4c1d9825"
  instance_type = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  security_groups = [ aws_security_group.jenkins_sg.name]
  tags = {
    Name="Jenkins-Server2"
  }
  user_data = <<-EOF
  #!/bin/bash
  sudo dnf update -y
  sudo dnf install java-17-amazon-corretto -y
  sudo curl -fsSL https://pkg.jenkins.io/redhat-stable/jenkins.repo \
  -o /etc/yum.repos.d/jenkins.repo
  sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
  sudo dnf install jenkins --nogpgcheck -y
  sudo systemctl enable jenkins
  sudo systemctl start jenkins
  EOF
}

