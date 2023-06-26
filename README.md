# Terraform AWS ECR Repositories

Terraform module to create and manage AWS infrastructure for ECR repositpories, including image scanning and vulnerabilities notifications.

![](./docs/img/tf_aws_ecr_repositories.png)

* [Module Features](#module-features)

* [Getting Started](#getting-started)

    * [Create an ECR Repository](#create-an-ecr-repository)

    * [Create an ECR Repository + Scanning + Notifications to an Existing SNS Topic](#create-an-ecr-repository--scanning--notifications-to-an-existing-sns-topic)

    * [Create an ECR Repository + Scanning + SNS Topic + Notifications](#create-an-ecr-repository--scanning--sns-topic--notifications)



## Module Features
<hr />

Aditionally to the reusability, portability, scalability and compliance that this module allows you to have in your ECR infrastructure, It also provides:

* **Image scanning**. It uses  ECR's vulnerability scanning capabilities, enabling the automatic scanning of container images for potential vulnerabilities.

* **Vulnerability notifications**. The module facilitates the configuration of notifications for identified vulnerabilities in container images. 

* **Customizable alerting**. You can configure different notification channels like webhooks, emails, etc. thanks to the SNS integration.

## Getting Started
<hr />

Find some examples listed below.

**NOTE**: Take a look to the variables section to get more details about the default configuration of each resource.

### Create an ECR Repository

This example shows you the configuration needed to create only a private ECR repository without image scanning nor notifications:

```terraform
module "example" {
  source = "github.com/wizeline/tf-aws-ecr-repository.git?ref=v0.0.1"
  
  name             = "example"
  ecr_scan_on_push = false
}

output "example_repo_url" {
  value = module.example.ecr_repo_url
}
```

### Create an ECR Repository + Scanning + Notifications to an Existing SNS Topic

The example below will show you how to create an ECR repository, enable image scanning (enabled by default) and notify about "MEDIUM" and higher vulnerabilities to an existing SNS topic.

```terraform
module "example" {
  source = "github.com/wizeline/tf-aws-ecr-repository.git?ref=v0.0.1"
  
  name                    = "example"
  create_image_monitoring = true
  image_severity_level    = "MEDIUM"
  sns_topic_arn           = <sns-topic-arn>
}

output "example_repo_url" {
  value = module.example.ecr_repo_url
}
```

### Create an ECR Repository + Scanning + SNS Topic + Notifications

Even though this module allows you to crete an SNS topic among the ECR repo, we highly recommend you to manage the SNS infrastructure separately in order to have reusability and cleaner code. But for those special cases, the example below will show you how to also create the SNS topic and related resources.

```terraform
module "example" {
  source = "github.com/wizeline/tf-aws-ecr-repository.git?ref=v0.0.1"
  
  name                    = "example"
  create_image_monitoring = true
  image_severity_level    = "MEDIUM"
  create_sns_topic        = true
  sns_topic_name          = "example-topic"
  sns_subscriptions = {
    "example@example.com" = "email"
  }
}

output "example_repo_url" {
  value = module.example.ecr_repo_url
}
```
