output "ecr_repo_url" {
  value       = aws_ecr_repository.this.repository_url
  description = "The URL of the repository (in the form aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName)."
}

output "sns_topic_arn" {
  value       = aws_sns_topic.this.*.arn
  description = "The ARN of the SNS topic, as a more obvious property (clone of id)."
}
