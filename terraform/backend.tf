terraform {
  backend "s3" {
    bucket         = "bucket-name"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true      
    dynamodb_table = "terraform-lock"
  }
}
