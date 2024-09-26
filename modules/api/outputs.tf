output "execution_arn" {
    value = aws_api_gateway_rest_api.logging_api.execution_arn
}
output "path_part" {
    value = aws_api_gateway_resource.root.path_part
}
output "invoke_url" {
    value = aws_api_gateway_deployment.deployment.invoke_url
}

output "deployment_id" {
    value = aws_api_gateway_deployment.deployment.id
}

output "rest_api_id" {
    value = aws_api_gateway_deployment.deployment.rest_api_id
}

output "rest_api_arn" {
    value = aws_api_gateway_rest_api.logging_api.arn
}