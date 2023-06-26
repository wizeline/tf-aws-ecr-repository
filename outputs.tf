output "ecr_repo_url" {
  value = aws_ecr_repository.this.repository_url
}

output "sns_topic_arn" {
  value = aws_sns_topic.this.*.arn
}
