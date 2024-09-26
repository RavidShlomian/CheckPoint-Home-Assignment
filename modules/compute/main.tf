resource "aws_lambda_function" "logging_lambda" {
  filename = "modules/storage/lambda_function.zip"
  function_name = "logging_lambda"
  role = var.lambda_exec_role
  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"
  timeout = "25"
   /*
  because the default timeout is set to 3 seconds and i need to fetch 
  data from github API and also write logs to s3 bucket i need to extend the timeout.
  */
  #s3_bucket = "lambda-check-point-ravidshlomian"                           #lambda bucket specification for version control 
  #s3_key  = "lambda_versions/lambda_versions"
}

#In order to enable API Gateway invokation i need to explicitly allow it
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.logging_lambda.function_name
  principal = "apigateway.amazonaws.com"
  /* the execution_arn and path_part needed for authentication 
  to the exact API and path value to triger the lambda
  */
  source_arn = "${var.execution_arn}/*/*/${var.path_part}"
}