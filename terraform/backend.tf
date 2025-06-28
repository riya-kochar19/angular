terraform {
  backend "s3" {
    bucket         = "angulardemo-project" # Replace with your bucket name
    key            = "terraform.tfstate"
    region         = "ap-northeast-3" # Replace with your AWS region
  }
}
