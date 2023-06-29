# Terraform AWS ECR Repositories

Terraform module to create and manage AWS infrastructure for ECR repositories, including image scanning and vulnerabilities notifications with Event Bridge and SNS.

![](./docs/img/tf_aws_ecr_repositories.png)

* [Module Features](#module-features)

* [Examples](#examples)

    * [Considerations](#considerations)

    * [Create an ECR Repository](#create-an-ecr-repository)

    * [Create an ECR Repository + Scanning + Notifications to an Existing SNS Topic](#create-an-ecr-repository--scanning--notifications-to-an-existing-sns-topics)

    * [Create an ECR Repository + Scanning + SNS Topic + Notifications](#create-an-ecr-repository--scanning--sns-topic--notifications)

* [Module Argument Reference](./docs/md/tf-docs.md)

## Module Features
<hr />

Aditionally, to the reusability, portability, scalability and compliance that this module allows you to have in your ECR infrastructure, It also provides:

* **Image scanning**. It uses  ECR's vulnerability scanning capabilities, enabling the automatic scanning of container images for potential vulnerabilities.

* **Vulnerability notifications**. The module facilitates the configuration of notifications for identified vulnerabilities in container images. 

* **Customizable alerting**. You can configure different notification channels like webhooks, emails, etc. thanks to the SNS integration.

## Examples
<hr />

### Considerations

There are a few considerations that can help you to prevent errors in your development:

* You can't manage topic subscriptions for SNS topics passed through `var.sns_topics_arns`. However, `var.sns_subscriptions` does allow you to manage topic subscriptions ONLY when the module creates the SNS topic through `var.create_sns_topic`.

* If you create an SNS topic through `var.create_sns_topic`, we highly recommend that you DO NOT make any reference to it in other resources outside the module, as it could cause cross-dependencies.

* Be careful when destroying the ECR repository created by this module. `var.ecr_force_delete` can prevent you from doing so if it is set to `false`. You will need to first change it to `true` or delete all the images within the repository.

**NOTE**: Take a look to the inputs section in [Module Argument Reference](/docs/md/tf-docs.md) to get more details about the default configuration of each resource.

### Create an ECR Repository

The example below shows you the configuration needed to create only a private ECR repository without image scanning nor notifications:

```terraform
module "example" {
  source = "github.com/wizeline/tf-aws-ecr-repository.git?ref=<version>"
  
  name             = "example"
  ecr_scan_on_push = false
}

output "example_repo_url" {
  value = module.example.ecr_repo_url
}
```

### Create an ECR Repository + Scanning + SNS Topic + Notifications

The example below shows you how to create an ECR repository, a SNS topic and the rules to get notifications from "MEDIUM" and higher vulnerabilities findings.

```terraform
module "example" {
  source = "github.com/wizeline/tf-aws-ecr-repository.git?ref=<version>"
  
  name                    = "example"
  create_image_monitoring = true
  image_severity_level    = "MEDIUM"
  create_sns_topic        = true
  sns_subscriptions = {
    "example@example.com" = "email"
  }
}

output "example_repo_url" {
  value = module.example.ecr_repo_url
}

output "example_topic_arn" {
  value = module.example.sns_topic_arn
}
```

### Create an ECR Repository + Scanning + Notifications to an Existing SNS Topic(s)

The example below will show you how to create an ECR repository, enable image scanning (enabled by default) and notify about "MEDIUM" and higher vulnerabilities to existing SNS topic(s).

```terraform
module "example" {
  source = "github.com/wizeline/tf-aws-ecr-repository.git?ref=<version>"
  
  name                    = "example"
  create_image_monitoring = true
  image_severity_level    = "MEDIUM"
  sns_topics_arns         = [ <arn-1>, <arn-2>... ]
}

output "example_repo_url" {
  value = module.example.ecr_repo_url
}
```

## [Module Argument Reference](./docs/md/tf-docs.md)
