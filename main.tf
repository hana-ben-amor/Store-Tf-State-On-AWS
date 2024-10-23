# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Define the Terraform backend to use S3 for state storage
terraform {
  backend "s3" {
    bucket = "my-terraform-state-hba"
    key    = "prod/key"
    region = "us-east-1"
  }
}

# Create an S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-terraform-test-bucket-hba"

}

# Create a security group
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
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

# Create a VPC for resources
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Create an EC2 instance
resource "aws_instance" "my_instance" {
  ami           = "ami-06b21ccaeff8cd686" # Amazon Linux 2 AMI in us-east-1
  instance_type = "t2.micro"

}
