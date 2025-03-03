provider "aws" {
  region = "us-east-1" # Ensure this is your correct AWS region
}

resource "aws_instance" "calculatorAngular" {
  ami           = "ami-04b4f1a9cf54c11d0" # Your existing Ubuntu AMI
  instance_type = "t2.micro"
  key_name      = "angluar" # Your actual AWS key pair

  # Attach existing security group
  vpc_security_group_ids = ["sg-032789747ef521238"] # Your actual Security Group ID
  
  associate_public_ip_address = true # Add this line

  tags = {
    Name = "calculatorAngular"
  }
}

