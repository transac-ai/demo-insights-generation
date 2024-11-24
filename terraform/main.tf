terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.76"
    }
  }

  required_version = ">= 1.5.6"
}

provider "aws" {
  region     = "us-east-2"
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

resource "aws_iam_role" "lambda_role" {
  name = "demo_insight_generation_lambda_role"

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
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "demo_insight_generation_lambda_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function" "insights_generation_lambda" {
  function_name = "insights_generation_handler"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.insights_generation_handler"
  runtime       = "nodejs22.x"
  architectures = ["arm64"]

  filename         = "insights_generation_lambda_pkg.zip"
  source_code_hash = filebase64sha256("insights_generation_lambda_pkg.zip")

  timeout = 10

  environment {
    variables = {
      WMS_API_URL                = var.WMS_API_URL
      WMS_API_KEY                = var.WMS_API_KEY
      RECORDS_SOURCE_ID          = var.RECORDS_SOURCE_ID
      PROMPT_TEMPLATES_SOURCE_ID = var.PROMPT_TEMPLATES_SOURCE_ID
      PROMPT_ID                  = var.PROMPT_ID
      CLIENT_ID                  = var.CLIENT_ID
    }
  }
}

resource "aws_iam_role" "eventbridge_role" {
  name = "insights_generation_eventbridge_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "eventbridge_policy" {
  name = "insights_generation_eventbridge_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = [
          aws_lambda_function.insights_generation_lambda.arn,
          "${aws_lambda_function.insights_generation_lambda.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eventbridge_policy_attachment" {
  role       = aws_iam_role.eventbridge_role.name
  policy_arn = aws_iam_policy.eventbridge_policy.arn
}

resource "aws_scheduler_schedule" "demo_insights_generation_schedule" {
  name       = "demo-insights-generation-schedule"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "rate(30 minute)"

  target {
    arn      = aws_lambda_function.insights_generation_lambda.arn
    role_arn = aws_iam_role.eventbridge_role.arn
  }
}

resource "aws_lambda_permission" "allow_eventbridge_invoke" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.insights_generation_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_scheduler_schedule.demo_insights_generation_schedule.arn
}