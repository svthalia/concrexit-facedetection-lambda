variable "stage" {
  description = "Deployment stage for resource names"
  type        = string
}

variable "image_tag" {
  description = "Tag of the Docker image to deploy"
  type        = string
}

variable "sentry_dsn" {
  description = "Sentry DSN for error reporting"
  type        = string
}
