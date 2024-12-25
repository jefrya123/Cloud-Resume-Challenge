provider "aws" {
  # Configures the AWS provider to interact with AWS resources
  region = "us-east-1" # Replace with your preferred AWS region
}

resource "aws_s3_bucket" "resume_bucket" {
  # Creates an S3 bucket for hosting the resume website
  bucket = "jeff-cloud-resume" # Unique bucket name
  force_destroy = true         # Ensures bucket is deleted even if it has objects

  website {
    # Configures the bucket for static website hosting
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    # Tags help organize and identify resources
    Name        = "Jeff Cloud Resume Bucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  # Ensures the bucket allows public access by disabling restrictive block settings
  bucket                  = aws_s3_bucket.resume_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "resume_policy" {
  # Sets a bucket policy to allow public read access to objects
  bucket = aws_s3_bucket.resume_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.resume_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "index_html" {
  # Uploads the index.html file to the S3 bucket
  bucket       = aws_s3_bucket.resume_bucket.bucket
  key          = "index.html" # The name of the file in the bucket
  source       = "index.html" # Path to the local file
  content_type = "text/html"  # Specifies the file's MIME type
}

resource "aws_s3_object" "style_css" {
  # Uploads the style.css file to the S3 bucket
  bucket       = aws_s3_bucket.resume_bucket.bucket
  key          = "style.css" # The name of the file in the bucket
  source       = "style.css" # Path to the local file
  content_type = "text/css"  # Specifies the file's MIME type
}
