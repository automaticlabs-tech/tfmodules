resource "aws_kms_key" "this" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.example.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this]

  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket" "this" {
  bucket = var.s3_name

    website {
    index_document = "index.html"
    error_document = "error.html"
	
    #routing_rules = <<EOF
    #                [{
    #                    "Condition": {
    #                        "KeyPrefixEquals": "docs/"
    #                    },
    #                    "Redirect": {
    #                        "ReplaceKeyPrefixWith": "documents/"
    #                    }
    #                }]
    #                EOF
  }

    tags = "${merge
            (var.s3_tags)
        }"
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
