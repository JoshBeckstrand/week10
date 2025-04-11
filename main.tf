# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.91.0"
#     }
#   }
# }

# provider "aws" {
#   region = "us-east-1"
# }

# resource "aws_instance" "example" {
#   ami           = "ami-0029fed53eea283c5" 
#   instance_type = "t2.micro"
# }
# variable "AWS_ACCESS_KEY_ID" {
#   type = string
#   description = "Acess key id"
# }

# variable "AWS_SECRET_ACCESS_KEY" {
#   type = string 
#   description = "Secret access key"

# }

# variable "AWS_SESSION_TOKEN" {
#   type = string
#   description = "Sesssion token"
  
# }
terraform {
  cloud {
    organization = "week10" 

    workspaces {
      name = "week10" 
    }
  }
}

  
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.91.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "example_sg" {
  name        = "example_sg"
  description = "Allow SSH and HTTP"

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

resource "aws_instance" "example" {
  ami           = "ami-0029fed53eea283c5"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example_sg.id]
}

resource "aws_eip" "example" {
  instance = aws_instance.example.id
}

output "instance_public_ip" {
  value = aws_eip.example.public_ip
}

output "security_group_id" {
  value = aws_security_group.example_sg.id
}


resource "aws_ebs_volume" "extra_volume" {
  availability_zone = aws_instance.example.availability_zone
  size              = 5 # 5 GB
  type              = "gp2"
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdf" # Might show as /dev/xvdf on the instance
  volume_id   = aws_ebs_volume.extra_volume.id
  instance_id = aws_instance.example.id
  force_detach = true
}


