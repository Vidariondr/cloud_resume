locals {
  layer_definitions = [
    {
      identifier = "layer1"
      path       = "${path.module}/layers/layer1"
    }
  ]
}

data "aws_caller_identity" "current_account" {}

resource "aws_s3_bucket" "lambda_layers_bucket" {
  bucket = "${data.aws_caller_identity.current_account.account_id}-lambda-layers-bucket"
}

resource "aws_s3_bucket_versioning" "lambda_layers_bucket" {
  bucket = aws_s3_bucket.lambda_layers_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

module "layers" {
  source   = "terraform-aws-modules/lambda/aws"
  version  = "~> 6.0"
  for_each = { for i in local.layer_definitions : i.identifier => i }

  create_layer        = true
  layer_name          = each.value.identifier
  compatible_runtimes = [var.python_runtime]

  source_path = [
    {
      path             = each.value.path
      pip_requirements = true
      prefix_in_zip    = "python"
    }
  ]

  store_on_s3 = true
  s3_bucket   = aws_s3_bucket.lambda_layers_bucket.bucket
}