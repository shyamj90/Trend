provider "aws" {
  
}

resource "aws_instance" "jenkins-server" {
  ami="ami-025ca978d4c1d9825"
  instance_type = "t3.micro"
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