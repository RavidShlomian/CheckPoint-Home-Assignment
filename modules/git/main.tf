#creating the git repo
resource "github_repository" "checkpo" {
 name        = "checkpoint-logging"
 description = "Welcome"
 visibility  = "public"
 auto_init   = true
}
#creating a branch 
resource "github_branch" "feature" {
 repository = github_repository.checkpo.name
 branch     = "dev3"
}


#The needed webhook with full path of the api to send the POST request to.
resource "github_repository_webhook" "pr" {
  repository = github_repository.checkpo.name

  configuration {
    url          = "${var.invoke_url}/${var.path_part}"
    content_type = "json"
    insecure_ssl = false
  }

  active = true

  events = ["pull_request"]
}