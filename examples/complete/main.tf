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

data "aws_caller_identity" "current" {}

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 1.0"

  for_each = var.resource_names_map

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  region                  = join("", split("-", var.region))
  class_env               = var.class_env
  cloud_resource_type     = each.value.name
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  maximum_length          = each.value.max_length
}

module "cloudwatch_log_group_wrapper" {
  source = "../.."

  cloudwatch_log_group_name                 = module.resource_names["log_group"].standard
  create_cloudwatch_log_stream              = var.create_cloudwatch_log_stream
  create_cloudwatch_log_subscription_filter = var.create_cloudwatch_log_subscription_filter
  cloudwatch_log_stream_name                = module.resource_names["log_stream"].standard
  subscription_filter_name                  = module.resource_names["subscription_filter"].standard
  firehose_delivery_stream_arn              = module.firehose_delivery_stream.arn
  subscription_filter_role                  = module.producer_role.assumable_iam_role

}

module "firehose_delivery_stream" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/firehose_delivery_stream/aws"
  version = "~> 1.0"

  delivery_stream_name   = module.resource_names["delivery_stream"].standard
  http_endpoint_url      = var.http_endpoint_url
  http_endpoint_name     = var.http_endpoint_name
  s3_error_output_prefix = var.s3_error_prefix
  s3_endpoint_bucket_arn = module.s3_bucket.arn
  consumer_role_arn      = module.consumer_role.assumable_iam_role

  tags = { resource_name = module.resource_names["delivery_stream"].standard }
}

module "s3_bucket" {
  source  = "terraform.registry.launch.nttdata.com/module_collection/s3_bucket/aws"
  version = "~> 1.0"

  enable_versioning = true
}

module "producer_role" {
  source  = "terraform.registry.launch.nttdata.com/module_collection/iam_assumable_role/aws"
  version = "~> 1.0.0"

  environment        = var.environment
  environment_number = var.environment_number
  region             = var.region
  resource_number    = var.resource_number

  assume_iam_role_policies = [data.aws_iam_policy_document.producer_policy.json]
  trusted_role_services    = local.producer_trusted_services
  role_sts_externalid      = local.producer_external_id

  resource_names_map = {
    iam_policy = var.resource_names_map["producer_policy"]
    iam_role   = var.resource_names_map["producer_role"]
  }
}

data "aws_iam_policy_document" "producer_policy" {
  statement {
    sid    = "StreamInteractions"
    effect = "Allow"
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]
    resources = [
      "arn:aws:firehose:${var.region}:${local.account_id}:deliverystream/${module.resource_names["delivery_stream"].standard}"
    ]
  }
}

module "consumer_role" {
  source  = "terraform.registry.launch.nttdata.com/module_collection/iam_assumable_role/aws"
  version = "~> 1.0.0"

  environment        = var.environment
  environment_number = var.environment_number
  region             = var.region
  resource_number    = var.resource_number

  assume_iam_role_policies = [data.aws_iam_policy_document.consumer_policy.json]
  trusted_role_services    = local.consumer_trusted_services
  role_sts_externalid      = local.consumer_external_id

  resource_names_map = {
    iam_policy = var.resource_names_map["consumer_policy"]
    iam_role   = var.resource_names_map["consumer_role"]
  }
}

data "aws_iam_policy_document" "consumer_policy" {
  statement {
    sid    = "FailedLogsS3Interactions"
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      module.s3_bucket.arn,
      "${module.s3_bucket.arn}/*"
    ]
  }

  statement {
    sid    = "PutLogEvents"
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream"
    ]
    resources = [
      module.cloudwatch_log_group_wrapper.cloudwatch_log_group_arn
    ]
  }

  statement {
    sid    = "StreamInteractions"
    effect = "Allow"
    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListShards"
    ]
    resources = [
      "arn:aws:firehose:${var.region}:${local.account_id}:deliverystream/${module.resource_names["delivery_stream"].standard}"
    ]
  }

  statement {
    sid    = "PassRole"
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "arn:aws:firehose:${var.region}:${local.account_id}:role/${module.resource_names["consumer_role"].standard}"
    ]
  }
}
