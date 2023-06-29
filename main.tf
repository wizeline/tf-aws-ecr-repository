#-----------------------------------
# Common
#-----------------------------------
data "aws_caller_identity" "current" {}

#-----------------------------------
# ECR
#-----------------------------------
resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.ecr_image_tag_immutability
  force_delete         = var.ecr_force_delete

  image_scanning_configuration {
    scan_on_push = var.ecr_scan_on_push
  }

  tags = merge(var.tags, var.ecr_tags)
}

#-----------------------------------
# Event Bridge
#-----------------------------------
resource "aws_cloudwatch_event_rule" "this" {
  for_each = var.create_image_monitoring ? toset(local.sub_severity_levels) : []

  name          = replace("${var.name}-${each.value}", "/", "-")
  description   = "Trigger events when ${var.name} images contain ${each.value} vulnerabilities."
  is_enabled    = var.enable_image_monitoring
  event_pattern = <<EOF
  {
    "detail-type": [
      "ECR Image Scan"
    ],
    "source": [
      "aws.ecr"
    ],
    "detail": {
      "repository-name": ["${var.name}"],
      "finding-severity-counts": {
        "${each.value}": [{"numeric": [">", 0]}]
      }
    }
  }
  EOF

  tags = merge(var.tags, var.event_bridge_tags)
}

resource "aws_cloudwatch_event_target" "multiple_arns" {
  for_each = var.create_image_monitoring && !var.create_sns_topic ? local.event_targets : {}

  rule = aws_cloudwatch_event_rule.this[each.value.level].name
  arn  = each.value.arn

  input_transformer {
    input_paths = {
      account         = "$.account",
      region          = "$.region",
      repository_name = "$.detail.repository-name",
      image_tag       = "$.detail.image-tags[0]",
      image_digest    = "$.detail.image-digest"
    }

    input_template = "\"ECR Scanning found ${each.value.level} vulnerabilities on <repository_name>:<image_tag>. More details: https://<region>.console.aws.amazon.com/ecr/repositories/private/<account>/<repository_name>/_/image/<image_digest>/scan-results?region=<region>\""
  }
}

# Resource to be created ONLY if var.create_sns_topic is true b/c Terraform can't
# determine "for_each" keys derived from resource attributes until apply.
resource "aws_cloudwatch_event_target" "single_arn" {
  for_each = var.create_image_monitoring && var.create_sns_topic ? toset(local.sub_severity_levels) : []

  rule = aws_cloudwatch_event_rule.this[each.value].name
  arn  = aws_sns_topic.this[0].arn

  input_transformer {
    input_paths = {
      account         = "$.account",
      region          = "$.region",
      repository_name = "$.detail.repository-name",
      image_tag       = "$.detail.image-tags[0]",
      image_digest    = "$.detail.image-digest"
    }

    input_template = "\"ECR Scanning found ${each.value} vulnerabilities on <repository_name>:<image_tag>. More details: https://<region>.console.aws.amazon.com/ecr/repositories/private/<account>/<repository_name>/_/image/<image_digest>/scan-results?region=<region>\""
  }
}

#-----------------------------------
# SNS
#-----------------------------------
resource "aws_sns_topic" "this" {
  count = var.create_image_monitoring && var.create_sns_topic ? 1 : 0

  name = var.sns_topic_name == "" ? replace("${var.name}-vuln", "/", "-") : var.sns_topic_name

  tags = merge(var.tags, var.sns_tags)
}

// Create SNS subcriptions ONLY for the topic created by this module
resource "aws_sns_topic_subscription" "this" {
  for_each = var.create_image_monitoring && var.create_sns_topic ? var.sns_subscriptions : {}

  topic_arn = aws_sns_topic.this[0].arn
  endpoint  = each.key
  protocol  = each.value
}

data "aws_iam_policy_document" "this" {
  count = var.create_image_monitoring && var.create_sns_topic ? 1 : 0

  statement {
    sid = "AllowAWSAccountToSNSTopic"

    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        data.aws_caller_identity.current.account_id
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.this[count.index].arn
    ]
  }

  statement {
    sid = "TrustEventBridgePublishEventsToSNSTopic"
    actions = [
      "sns:Publish"
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.this[count.index].arn
    ]
  }
}

resource "aws_sns_topic_policy" "this" {
  count = var.create_image_monitoring && var.create_sns_topic ? 1 : 0

  arn    = aws_sns_topic.this[count.index].arn
  policy = data.aws_iam_policy_document.this[count.index].json
}
