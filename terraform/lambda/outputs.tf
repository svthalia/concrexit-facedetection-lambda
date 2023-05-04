output "lambda_arn" {
  description = "ARN of the lambda function, to be used from concrexit"
  value       = aws_lambda_function.this.arn
}
