output "web_acl_arn" {
  value = aws_wafv2_web_acl.api_gateway_acl.id
}
