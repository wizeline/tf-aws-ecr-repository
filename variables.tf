#-----------------------------------------------------------
# Control Variables
#-----------------------------------------------------------
variable "name" {
  type        = string
  description = "(Required) This name will be used in all resources created by this module."
}

variable "tags" {
  type        = map(string)
  description = "(Optional) Tags applied to all resources created by this module."
  default     = {}
}

variable "create_image_monitoring" {
  type        = bool
  description = "(Optional) Whether create resources to monitor image vulnerabilities or not."
  default     = false
}

variable "enable_image_monitoring" {
  type        = bool
  description = "(Optional) Whether enable image vulnerabilities monitoring or not."
  default     = true
}

variable "image_severity_level" {
  type        = string
  description = "(Optional) Indicates the severity level in the scan findings that will be monitored. It follows a herarchical order. E.g. If set to \"HIGH\", \"HIGH\" and \"CRITICAL\" findings will be monitored."
  validation {
    condition     = can(regex("^(LOW|MEDIUM|HIGH|CRITICAL)$", var.image_severity_level))
    error_message = "Invalid input, valida options: \"LOW\", \"MEDIUM\", \"HIGH\", \"CRITICAL\"."
  }
  default = "HIGH"
}

variable "create_sns_topic" {
  type        = bool
  description = "(Optional) Whether create an SNS topic or not."
  default     = false
}

variable "sns_topic_arn" {
  type        = string
  description = "(Optional) ARN of the existing SNS topic. Existing SNS topic must the right policy."
  default     = ""
}

#-----------------------------------------------------------
# ECR
#-----------------------------------------------------------
variable "ecr_image_tag_immutability" {
  type        = string
  description = "(Optional) The tag mutability setting for the repository."
  validation {
    condition     = can(regex("^(MUTABLE|IMMUTABLE)$", var.ecr_image_tag_immutability))
    error_message = "Invalid input, valid options: \"MUTABLE\", \"IMMUTABLE\"."
  }
  default = "MUTABLE"
}

variable "ecr_force_delete" {
  type        = bool
  description = "(Optional) If true, will delete the repository even if it contains images."
  default     = true
}

variable "ecr_scan_on_push" {
  type        = bool
  description = "(Optional) Indicates whether images are scanned after being pushed to the repository or not scanned."
  default     = true
}

variable "ecr_tags" {
  type        = map(string)
  description = "(Optional) Tags dedicated to ECR resources."
  default     = {}
}

#-----------------------------------------------------------
# Event Bridge
#-----------------------------------------------------------
variable "event_bridge_tags" {
  type        = map(string)
  description = "(Optional) Tags dedicated to Event Bridge resources."
  default     = {}
}

#-----------------------------------------------------------
# SNS
#-----------------------------------------------------------
variable "sns_topic_name" {
  type        = string
  description = "(Optional) The name of the topic."
  default     = ""
}

variable "sns_subscriptions" {
  type        = map(string)
  description = "(Optional) Subscriber endpoints and subscriber protocols in the form of: \"endpoint\"=\"protocol\"."
  validation {
    condition = length([
      for p in var.sns_subscriptions : true
      if contains(["sqs", "sms", "lambda", "firehose", "application", "email", "email-json", "http", "https"], p)
    ]) == length(var.sns_subscriptions)
    error_message = "Invalid input. Valid protocol values: \"sqs\", \"sms\", \"lambda\", \"firehose\", \"application\", \"email\", \"email-json\", \"http\", \"https\"."
  }
  default = {}
}

variable "sns_tags" {
  type        = map(string)
  description = "(Optional) Tags dedicated to SNS resources."
  default     = {}
}
