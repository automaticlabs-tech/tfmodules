resource "aws_kms_key" "this" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.this.arn
      sse_algorithm     = "aws:kms"
    }
  }
 }

# resource "aws_s3_bucket_ownership_controls" "this" {
#   bucket = aws_s3_bucket.this.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

resource "aws_s3_bucket_acl" "this" {
  #depends_on = [aws_s3_bucket_ownership_controls.this]

  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket" "this" {
  bucket = var.s3_name

  versioning {
    enabled = false
  }

    website {
    index_document = var.cloudfront_default_root_object
    error_document = var.cloudfront_default_error_object
    }

    tags = "${merge
            (var.s3_tags)
    }"
}

# resource "aws_s3_bucket_policy" "this" {
#   bucket = aws_s3_bucket.this.id

#   policy = jsonencode({
#     "Version" : "2008-10-17",
#     "Statement" : [
#       {
#         "Sid" : "AllowCloudFrontServicePrincipalReadOnly",
#         "Effect" : "Allow",
#         "Principal" : {
#           "Service" : "cloudfront.amazonaws.com",
#         },
#         "Action" : "s3:GetObject",
#         "Resource" : "arn:aws:s3:::${aws_s3_bucket.this.bucket}/*",
#         "Condition" : {
#           "StringEquals" : {
#             "aws:SourceArn" : aws_cloudfront_distribution.this.arn
#           }
#         }
#       }
#     ]
#   })

#   depends_on = [
#     aws_s3_bucket.this
#   ]
# }