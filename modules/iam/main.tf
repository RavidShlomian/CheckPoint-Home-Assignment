#To avoid exposing the region and account number I'll use the following data blocks
#Also needed for restricted access for resources.
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

#IAM role for lambda execution, assumed by lambda Service
#Attached in the inline policy a KMS section because my github token is encrypted

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  inline_policy {
    name = "lambda-write-to-s3"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "arn:aws:logs:*:*:*"
        },
        {
          "Effect" : "Allow",
          "Action" : "s3:PutObject",
          "Resource" : ["arn:aws:s3:::logging-bucket-check-point-ravidshlomian/*"]
        },
                {
          "Effect" : "Allow",
          "Action" : "s3:GetObject",
          "Resource" : ["arn:aws:s3:::lambda-check-point-ravidshlomian/*"]
        },
        {
          "Effect" : "Allow",
          "Action" : "ssm:GetParameter",
          "Resource" : "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/github-token"
        },
        {
          "Effect" : "Allow",
          "Action" : "kms:Decrypt",
          "Resource" : "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/*"
        }

      ]
    })
  }
}

#The needed policy, using the managed one from aws
data "aws_iam_policy" "lambda-exec" {
  name = "AmazonS3ObjectLambdaExecutionRolePolicy"
}

#attaching managed policy to the role
resource "aws_iam_policy_attachment" "policy-attach" {
  name       = "lambda-role-policy-attachment"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = data.aws_iam_policy.lambda-exec.arn
}
#attaching another policy to the role (for logs)
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.lambda_exec_role.name
}

