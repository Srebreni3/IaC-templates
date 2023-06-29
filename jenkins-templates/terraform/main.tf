resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-tf-test"
  description = "Security group for jenkins"
  
  vpc_id = "your-vpc"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins-tf-test" {
  ami           = "your-ami"
  instance_type = "t2.micro"
  key_name      = "ahmed-srebrenica-web-server-key"
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = "jenkins-tf-test"
    CreatedBy = "ahmed.srebrenica"
    Project = "jenkins-test"
    IaC = "Terraform"
  }
}

