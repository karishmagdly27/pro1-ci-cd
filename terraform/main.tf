##########################
# Fetch latest Ubuntu 22.04 AMI
##########################
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical Ubuntu
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

##########################
# Jenkins Security Group #
##########################
resource "aws_security_group" "jenkins_sg" {
  name = "jenkins-sg"

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

  ingress {
    from_port   = 9000
    to_port     = 9000
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

##################
# App Security Group #
##################
resource "aws_security_group" "app_sg" {
  name = "app-sg"

  ingress { 
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress { 
    from_port   = 80
    to_port     = 80
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

#########################
# Nexus Security Group  #
#########################
resource "aws_security_group" "nexus_sg" {
  name = "nexus-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
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

##################
# EC2 Instances #
##################

# Jenkins
resource "aws_instance" "jenkins" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.large"
  key_name        = var.key_name
  security_groups = [aws_security_group.jenkins_sg.name]
  tags = { Name = "jenkins-server" }
}

# Nexus
resource "aws_instance" "nexus" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.xlarge"
  key_name        = var.key_name
  security_groups = [aws_security_group.nexus_sg.name]
  tags = { Name = "nexus-server" }
}

# App Environment Instances (Dev, Staging, Prod)
resource "aws_instance" "app" {
  for_each        = { 
                      dev     = "app-dev",
                      staging = "app-staging",
                      prod    = "app-prod"
                    }
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.micro"
  key_name        = var.key_name
  security_groups = [aws_security_group.app_sg.name]
  tags = { Name = each.value }
}
