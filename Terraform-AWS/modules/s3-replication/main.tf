# --------------------------------------------------
# S3 Buckets
# --------------------------------------------------

resource "aws_s3_bucket" "primary" {
  provider = aws.primary
  bucket   = var.primary_bucket_name
}

resource "aws_s3_bucket" "secondary" {
  provider = aws.secondary
  bucket   = var.secondary_bucket_name
}


# --------------------------------------------------
# S3 Versioning
# --------------------------------------------------

resource "aws_s3_bucket_versioning" "primary" {
  provider = aws.primary
  bucket   = aws_s3_bucket.primary.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "secondary" {
  provider = aws.secondary
  bucket   = aws_s3_bucket.secondary.id

  versioning_configuration {
    status = "Enabled"
  }
}


# --------------------------------------------------
# S3 Encryption
# --------------------------------------------------

resource "aws_s3_bucket_server_side_encryption_configuration" "primary" {
  provider = aws.primary
  bucket   = aws_s3_bucket.primary.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "secondary" {
  provider = aws.secondary
  bucket   = aws_s3_bucket.secondary.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# --------------------------------------------------
# S3 Public Access Block
# --------------------------------------------------

resource "aws_s3_bucket_public_access_block" "primary" {
  provider = aws.primary
  bucket   = aws_s3_bucket.primary.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "secondary" {
  provider = aws.secondary
  bucket   = aws_s3_bucket.secondary.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# --------------------------------------------------
# IAM Role for S3 Replication
# --------------------------------------------------

resource "aws_iam_role" "replication" {
  provider = aws.primary

  name = "${var.project_name}-s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "s3.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}


# --------------------------------------------------
# IAM Replication Policy
# --------------------------------------------------

resource "aws_iam_policy" "replication" {
  provider = aws.primary

  name = "${var.project_name}-s3-replication-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]

        Resource = aws_s3_bucket.primary.arn
      },
      {
        Effect = "Allow"

        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]

        Resource = "${aws_s3_bucket.primary.arn}/*"
      },
      {
        Effect = "Allow"

        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]

        Resource = "${aws_s3_bucket.secondary.arn}/*"
      }
    ]
  })
}


# --------------------------------------------------
# Attach IAM Policy to Role
# --------------------------------------------------

resource "aws_iam_role_policy_attachment" "replication" {
  provider = aws.primary

  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}


# --------------------------------------------------
# S3 Cross-Region Replication
# --------------------------------------------------

resource "aws_s3_bucket_replication_configuration" "replication" {
  provider = aws.primary

  bucket = aws_s3_bucket.primary.id
  role   = aws_iam_role.replication.arn

  rule {
    id     = "replicate-to-singapore"
    status = "Enabled"

    filter {}

    destination {
      bucket        = aws_s3_bucket.secondary.arn
      storage_class = "STANDARD"
    }


    delete_marker_replication {
      status = "Disabled"
    }



  }

  depends_on = [
    aws_s3_bucket_versioning.primary,
    aws_s3_bucket_versioning.secondary,
    aws_iam_role_policy_attachment.replication
  ]
}