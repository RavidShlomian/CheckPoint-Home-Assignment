#getting the variables in order to set the path for sending the requests to.
variable "invoke_url" {
    description = "api endpoint for github webhook"
    type = string
}

variable "path_part" {
    description = "path section for api endpoint"
    type = string
}