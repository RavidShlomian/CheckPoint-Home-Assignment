module "git" {
  source     = "./modules/git"
  invoke_url = module.api.invoke_url
  path_part  = module.api.path_part
}

module "storage" {
  source = "./modules/storage"
}
module "iam" {
  source = "./modules/iam"
}

module "api" {
  source     = "./modules/api"
  invoke_arn = module.compute.invoke_arn
}

module "compute" {
  source                = "./modules/compute"
  lambda_exec_role      = module.iam.lambda_exec_role
  execution_arn         = module.api.execution_arn
  path_part             = module.api.path_part
  lambda_version_bucket = module.storage.lambda_version_bucket
}

module "waf" {
  source        = "./modules/waf"
  rest_api_id   = module.api.rest_api_id
  deployment_id = module.api.deployment_id
  rest_api_arn  = module.api.rest_api_arn
}

output "lambda_version_bucket" {
  value = module.storage.lambda_version_bucket
}
