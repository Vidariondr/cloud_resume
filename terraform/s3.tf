resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name
}

data "aws_iam_policy_document" "origin_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.website.arn}/*"]

    condition {
      test     = "ArnLike"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
  version = "2008-10-17"
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.website.bucket
  policy = data.aws_iam_policy_document.origin_bucket_policy.json
}

resource "aws_s3_object" "s3_object_upload" {
  bucket   = aws_s3_bucket.website.bucket
  for_each = fileset("../src/frontend", "**")
  key      = each.value
  source   = "../src/frontend"
  content_type = (
    endswith(each.value, ".html") ? "text/html"
    : endswith(each.value, ".css") ? "text/css"
    : endswith(each.value, ".js") ? "application/javascript"
    : endswith(each.value, ".webp") ? "image/webp"
    : "application/octet-stream"
  )
  etag = filemd5("../src/frontend/${each.value}")
}