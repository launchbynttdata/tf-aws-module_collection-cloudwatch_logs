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

variable "cloudwatch_log_group_name" {
  description = "(Required) Cloudwatch log group name."
  type        = string
}

variable "cloudwatch_log_stream_name" {
  description = "(Optional) Cloudwatch log stream name."
  type        = string
  default     = null
}

variable "create_cloudwatch_log_stream" {
  description = "AWS cloudwatch log stream"
  type        = bool
  default     = false
}

variable "create_cloudwatch_log_subscription_filter" {
  description = "AWS cloudwatch log subscription filter"
  type        = bool
  default     = false
}

variable "subscription_filter_name" {
  description = "(Optional) The name if the subscription filter to be associated with cloudwatch log stream."
  type        = string
  default     = null
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
