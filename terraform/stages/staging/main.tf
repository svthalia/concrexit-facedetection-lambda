terraform {
  required_version = ">=0.14.10"

  required_providers {
    aws = ">= 4.65.0"
  }

  backend "s3" {
    bucket  = "thalia-terraform-state"
    key     = "concrexit-facedetection-lambda/staging.tfstate"
    region  = "eu-west-1"
    profile = "thalia"
  }
}

module "lambda" {
  source     = "../../lambda"
  stage      = "staging"
  image_tag  = "latest"
  sentry_dsn = var.sentry_dsn
}
