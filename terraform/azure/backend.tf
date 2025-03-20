terraform {
  backend "s3" {
    bucket = "devops-sciit-backend"
    key    = "infra/azure.tfstate"
    region = "us-east-1"
  }
}
