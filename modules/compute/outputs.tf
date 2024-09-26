#outputing the invoke arn for api gatwway integration
output "invoke_arn" {
    value = aws_lambda_function.logging_lambda.invoke_arn
}

