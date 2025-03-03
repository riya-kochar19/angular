terraform {
  backend "s3" {
    bucket         = "statefilebackup99" # Replace with your bucket name
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}
