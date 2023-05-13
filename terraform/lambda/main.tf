
provider "aws" {
  profile = "thalia"
  region  = "eu-west-1"
}

locals {
  tags = {
    Category    = "concrexit-facedetection-lambda",
    Owner       = "technicie",
    Environment = var.stage,
    Terraform   = true
  }
}

data "aws_ecr_repository" "this" {
  name = "concrexit/facedetection-lambda"
}

data "aws_ecr_image" "this" {
  repository_name = data.aws_ecr_repository.this.name
  image_tag       = var.image_tag
}

resource "aws_lambda_function" "this" {
  function_name = "concrexit-${var.stage}-facedetection-lambda"
  role          = aws_iam_role.this.arn

  package_type = "Image"
  image_uri    = "${data.aws_ecr_repository.this.repository_url}@${data.aws_ecr_image.this.image_digest}"

  memory_size = 512
  timeout     = 720

  tags = local.tags
}

resource "aws_iam_role" "this" {
  name = "concrexit-${var.stage}-facedetection-lambda-iam-role"
  tags = local.tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}
