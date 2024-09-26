resource "aws_wafv2_ip_set" "ipv4_set" {
  name               = "ipv4-set"
  description        = "ip set for ipv4 addresses"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses = [
    "192.30.252.0/22",
    "185.199.108.0/22",
    "140.82.112.0/20",
    "143.55.64.0/20",
    "192.30.252.0/22",
    "185.199.108.0/22",
    "140.82.112.0/20",
    "143.55.64.0/20",
    "20.201.28.148/32",
    "20.205.243.168/32",
    "20.87.245.6/32",
    "4.237.22.34/32",
    "20.207.73.85/32",
    "20.27.177.116/32",
    "20.200.245.245/32",
    "20.175.192.149/32",
    "20.233.83.146/32",
    "20.29.134.17/32",
    "20.199.39.228/32",
    "4.208.26.200/32",
    "20.26.156.210/32"
  ]

}


resource "aws_wafv2_ip_set" "ipv6_set" {
  name               = "ipv6-set"
  description        = "ip set for ipv6 addresses"
  scope              = "REGIONAL"
  ip_address_version = "IPV6"
  addresses = [
    "2a0a:a440::/29",
    "2606:50c0::/32"
  ]
}
/*
resource "aws_wafv2_rule_group" "ip_rule_group" {
  name     = "allowed-ip-rule"
  scope    = "REGIONAL"
  capacity = 2

  rule {
    name     = "Github-IPv4-allowed-addresses"
    priority = 0
    action {
      allow {}
    }
    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ipv4_set.arn
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rule0"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "Github-IPv6-allowed-addresses"
    priority = 1
    action {
      allow {}
    }
    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ipv6_set.arn
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rule1"
      sampled_requests_enabled   = true
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "ip-rule-group"
    sampled_requests_enabled   = true
  }
}
*/

resource "aws_wafv2_web_acl" "api_gateway_acl" {
  name  = "github-api-gateway-waf-acl"
  scope = "REGIONAL"
  default_action {
    block {}
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "git-api-waf-rule"
    sampled_requests_enabled   = true
  }
  rule {
    name     = "allowed-ipv4"
    priority = 0
    action {
        allow {}
    }
    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ipv4_set.arn
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "api-gtw-waf-ipv4"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "allowed-ipv6"
    priority = 1
    action {
        allow {}
    }
    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ipv6_set.arn
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "api-gtw-waf-ipv6"
      sampled_requests_enabled   = true
    }
  }
}


#I tried not to hardcode the stage name in the api_waf_association but couldn't find appropriate 
#attribute to use  in the aws_api_gateway_deployment and aws_api_gateway_stage resource blocks

resource "aws_wafv2_web_acl_association" "api_waf_association" {
  resource_arn = "${var.rest_api_arn}/stages/dev"
  web_acl_arn  = aws_wafv2_web_acl.api_gateway_acl.arn
  depends_on = [
    aws_wafv2_web_acl.api_gateway_acl
  ]
}