output "primary_bucket_arn" {
  value = aws_s3_bucket.primary.arn

}

output "secondary_bucket_arn" {
  value = aws_s3_bucket.secondary.arn
}


output "replication_role_arn" {
  value = aws_iam_role.replication.arn
}