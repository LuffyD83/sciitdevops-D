terraform {
  backend "s3" {
    bucket = "devops-sciit-backend"
    key    = "infra/aws.tfstate"
    region = "eu-west-1"
  }
}
