## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.multiple_arns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_event_target.single_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_image_monitoring"></a> [create\_image\_monitoring](#input\_create\_image\_monitoring) | (Optional) Whether create resources to monitor image vulnerabilities or not. | `bool` | `false` | no |
| <a name="input_create_sns_topic"></a> [create\_sns\_topic](#input\_create\_sns\_topic) | (Optional) Whether create an SNS topic or not. Choose between this or provide existing SNS topics ARNs through "var.sns\_topics\_arns". | `bool` | `false` | no |
| <a name="input_ecr_force_delete"></a> [ecr\_force\_delete](#input\_ecr\_force\_delete) | (Optional) If true, will delete the repository even if it contains images. | `bool` | `true` | no |
| <a name="input_ecr_image_tag_immutability"></a> [ecr\_image\_tag\_immutability](#input\_ecr\_image\_tag\_immutability) | (Optional) The tag mutability setting for the repository. | `string` | `"MUTABLE"` | no |
| <a name="input_ecr_scan_on_push"></a> [ecr\_scan\_on\_push](#input\_ecr\_scan\_on\_push) | (Optional) Indicates whether images are scanned after being pushed to the repository or not scanned. | `bool` | `true` | no |
| <a name="input_ecr_tags"></a> [ecr\_tags](#input\_ecr\_tags) | (Optional) Tags dedicated to ECR resources. | `map(string)` | `{}` | no |
| <a name="input_enable_image_monitoring"></a> [enable\_image\_monitoring](#input\_enable\_image\_monitoring) | (Optional) Whether enable image vulnerabilities monitoring or not. | `bool` | `true` | no |
| <a name="input_event_bridge_tags"></a> [event\_bridge\_tags](#input\_event\_bridge\_tags) | (Optional) Tags dedicated to Event Bridge resources. | `map(string)` | `{}` | no |
| <a name="input_image_severity_level"></a> [image\_severity\_level](#input\_image\_severity\_level) | (Optional) Indicates the severity level in the scan findings that will be monitored. It follows a herarchical order. E.g. If set to "HIGH", "HIGH" and "CRITICAL" findings will be monitored. | `string` | `"HIGH"` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) This name will be used in all resources created by this module. | `string` | n/a | yes |
| <a name="input_sns_subscriptions"></a> [sns\_subscriptions](#input\_sns\_subscriptions) | (Optional) Subscriber endpoints and subscriber protocols in the form of: "endpoint"="protocol". | `map(string)` | `{}` | no |
| <a name="input_sns_tags"></a> [sns\_tags](#input\_sns\_tags) | (Optional) Tags dedicated to SNS resources. | `map(string)` | `{}` | no |
| <a name="input_sns_topic_name"></a> [sns\_topic\_name](#input\_sns\_topic\_name) | (Optional) The name of the topic. | `string` | `""` | no |
| <a name="input_sns_topics_arns"></a> [sns\_topics\_arns](#input\_sns\_topics\_arns) | (Optional) ARNs of the existing SNS topics where the alert messages will be sent. Choose between this or creating a new SNS topic through "var.create\_sns\_topic". | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Tags applied to all resources created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_repo_url"></a> [ecr\_repo\_url](#output\_ecr\_repo\_url) | The URL of the repository (in the form aws\_account\_id.dkr.ecr.region.amazonaws.com/repositoryName). |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | The ARN of the SNS topic, as a more obvious property (clone of id). |
