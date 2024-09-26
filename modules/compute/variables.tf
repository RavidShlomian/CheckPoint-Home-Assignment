variable "lambda_exec_role" {
    description = "lambda exec role for logging"
    type = string
}

variable "execution_arn" {
    description = "execution_arn for lambda api permissions"
    type = string
}

variable "path_part" {
    description = "path for lambda api permissions"
    type = string
}

variable "lambda_version_bucket" {
    description = "s3 bucket name for lambda versioning"
    type = string
}