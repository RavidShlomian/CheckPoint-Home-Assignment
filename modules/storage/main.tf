#bucket dedicated to tfstate file for remote managing of terraform
resource "aws_s3_bucket" "terraform_state_check_point" {
  bucket        = "terraform-backend-bucket-check-point-ravidshlomian"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state_check_point.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_crypto_conf" {
  bucket = aws_s3_bucket.terraform_state_check_point.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
#state locking so there wont be any chance for 2 or more write to the bucket at the same time
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
#s3 bucket for writing the logs to.
resource "aws_s3_bucket" "logging_check_point" {
  bucket        = "logging-bucket-check-point-ravidshlomian"
  force_destroy = true
}


resource "aws_s3_bucket" "lambda_versions_check_point" {
  bucket        = "lambda-check-point-ravidshlomian"
  force_destroy = true
}

resource "aws_s3_object" "file_upload_versions" {
  bucket = aws_s3_bucket.lambda_versions_check_point.bucket
  key    = "lambda_versions/lambda_versions"  
  source = "./modules/storage/lambda_function.zip"     # Path to local file
  acl    = "private"
}

resource "aws_s3_object" "file_upload_logs" {
  bucket = aws_s3_bucket.logging_check_point.bucket
  key    = "logs/merged/logs.txt"  
  source = "./modules/storage/logs.txt"     # Path to local file
  acl    = "private"
}