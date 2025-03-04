provider "aws" {
  region = "us-east-1" # Ensure this is your correct AWS region
}

# Create the EC2 Instance
resource "aws_instance" "calculatorAngular" {
  ami                    = "ami-04b4f1a9cf54c11d0" # Your existing Ubuntu AMI
  instance_type          = "t2.micro"
  key_name               = "angluar" # Ensure the key pair exists in AWS
  vpc_security_group_ids = ["sg-032789747ef521238"] # Your actual Security Group ID

  tags = {
    Name = "calculatorAngular"
  }
}

# Allocate an Elastic IP (EIP)
resource "aws_eip" "angular_eip" {
  instance = aws_instance.calculatorAngular.id
}


