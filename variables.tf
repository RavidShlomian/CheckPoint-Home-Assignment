
variable "aws_region" {
  description = "The region to configure"
  type        = string
}

variable "github_token" {
  description = "Github access token"
  type        = string
  sensitive   = true
}

