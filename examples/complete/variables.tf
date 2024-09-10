// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

variable "create_cloudwatch_log_stream" {
  description = "Flag to indicte if AWS cloudwatch log stream needs to be created."
  type        = bool
  default     = false
}

variable "create_cloudwatch_log_subscription_filter" {
  description = "Flag to indicte if  AWS cloudwatch log subscription filter needs to be created."
  type        = bool
  default     = false
}

variable "subscription_filter_role" {
  description = "(Optional)  The ARN of an IAM role that grants Amazon CloudWatch Logs permissions to deliver ingested log events to the destination.This role should have permissions to PutRecord and PutRecordBatch on the delivery stream."
  type        = string
  default     = null
}

variable "firehose_delivery_stream_arn" {
  description = "(Optional) ARN of the Kinesis data firehose where ingested logs by cloudwatch log stream are sent."
  type        = string
  default     = null
}

variable "subscription_filter_pattern" {
  description = "(Optional) Filter expression used to filter records coming out of the Log Group. The default (empty string) will send all log records."
  type        = string
  default     = ""
}

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object(
    {
      name       = string
      max_length = optional(number, 60)
    }
  ))
  default = {
    log_group = {
      name       = "lg"
      max_length = 63
    }
    log_stream = {
      name       = "ls"
      max_length = 63
    }
    subscription_filter = {
      name       = "sub-fltr"
      max_length = 63
    }
    delivery_stream = {
      name       = "ds"
      max_length = 63
    }
    producer_role = {
      name       = "prdcr-role"
      max_length = 63
    }
    producer_policy = {
      name       = "prdcr-plcy"
      max_length = 63
    }
    consumer_policy = {
      name       = "cnsmr-plcy"
      max_length = 60
    }
    consumer_role = {
      name       = "cnsmr-role"
      max_length = 60
    }
  }
}

variable "region" {
  description = "AWS Region in which the infra needs to be provisioned"
  default     = "us-east-2"
}

variable "naming_prefix" {
  description = "Prefix for the provisioned resources."
  type        = string
  default     = "platform"
}

variable "environment" {
  description = "Environment in which the resource should be provisioned like dev, qa, prod etc."
  type        = string
  default     = "dev"
}

variable "environment_number" {
  description = "The environment count for the respective environment. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "resource_number" {
  description = "The resource count for the respective resource. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "http_endpoint_url" {
  description = "URL to which the Delivery Stream should deliver its records."
  type        = string
}

variable "http_endpoint_name" {
  description = "Friendly name for the HTTP endpoint associated with this Delivery Stream."
  type        = string
}

variable "s3_error_prefix" {
  description = "Prefix to prepend to failed records being sent to S3. Ensure this value contains a trailing slash if set to anything other than an empty string."
  type        = string
  default     = ""
}

variable "producer_external_id" {
  description = "STS External ID used for the assumption policy when creating the producer role."
  type        = list(string)
  default     = null
}

variable "producer_trusted_service" {
  description = "Trusted service used for the assumption policy when creating the producer role. Defaults to the logs service for the current AWS region."
  type        = string
  default     = null
}

variable "producer_policy_json" {
  description = "Policy JSON containing rights for the producer role. If not specified, will build a producer policy for CloudWatch Logs."
  type        = string
  default     = null
}

variable "consumer_trusted_services" {
  description = "Trusted service used for the assumption policy when creating the consumer role. Defaults to the firehose service."
  type        = string
  default     = null
}

variable "consumer_external_id" {
  description = "STS External ID used for the assumption policy when creating the consumer role. Defaults to the current AWS account ID."
  type        = string
  default     = null
}
