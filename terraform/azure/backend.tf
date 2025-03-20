terraform {
  backend "s3" {
    bucket = "devops-sciit-backend"
    key    = "infra/azure.tfstate"
    region = "West Europe"
  }
}
