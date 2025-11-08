data "aws_iam_policy_document" "visitor_counter_function_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "archive_file" "lambda_archive" {
  type        = "zip"
  source_file = "../src/backend/app.py"
  output_path = "../src/backend/function.zip"
}

resource "aws_iam_role" "visitor_counter_function_role" {
  name               = "lambda_dynamodb_full_access_role"
  assume_role_policy = data.aws_iam_policy_document.visitor_counter_function_role.json
}

resource "aws_lambda_function" "visitor_counter_function" {
  filename      = data.archive_file.lambda_archive.output_path
  function_name = "visitor_counter_function"
  handler       = "app.lambda_handler"
  role          = aws_iam_role.visitor_counter_function_role.arn
  runtime       = var.python_runtime
  ephemeral_storage {
    size = 512
  }
  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/visitor_counter_function"
  }
}