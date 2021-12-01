module "template_files" {
  source  = "hashicorp/dir/template"
  version = "1.0.2"
  base_dir = "${path.module}/../build"
}

resource "aws_s3_bucket" "s3_www_bucket" {
  bucket        = "${var.s3_www_bucket}"
  acl           = "public-read"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::${var.s3_www_bucket}/*"
      }
    ]
  })
  force_destroy = true
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
  tags = {
    Owner = "Andreas.Rotaru"
  }
}

resource "aws_s3_bucket_object" "s3_webpage" {
  bucket   = aws_s3_bucket.s3_www_bucket.id
  acl      = "public-read"
  for_each = module.template_files.files
  key          = each.key
  content_type = each.value.content_type
  source  = each.value.source_path
  content = each.value.content
  etag = each.value.digests.md5
}