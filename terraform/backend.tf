terraform {
  backend "s3" {
    bucket         = "angulardemo-project" # Replace with your bucket name
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}
