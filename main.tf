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
module "cloudwatch_log_group" {
  source = "git::https://github.com/launchbynttdata/tf-aws-module_primitive-cloudwatch_log_group?ref=1.0.0"

  name = var.cloudwatch_log_group_name
}

module "cloudwatch_log_stream" {
  source = "git::https://github.com/launchbynttdata/tf-aws-module_primitive-cloudwatch_log_stream?ref=1.0.0"

  count = var.create_cloudwatch_log_stream ? 1 : 0

  name                      = var.cloudwatch_log_stream_name
  cloudwatch_log_group_name = var.cloudwatch_log_group_name

  depends_on = [module.cloudwatch_log_group]
}

module "cloudwatch_log_subscription_filter" {
  source = "git::https://github.com/launchbynttdata/tf-aws-module_primitive-cloudwatch_subscription_filter?ref=1.0.0"

  count = var.create_cloudwatch_log_subscription_filter ? 1 : 0

  subscription_filter_name                = var.subscription_filter_name
  subscription_filter_role_arn            = var.subscription_filter_role
  cloudwatch_log_group_name               = var.cloudwatch_log_group_name
  subscription_filter_delivery_stream_arn = var.firehose_delivery_stream_arn
  subscription_filter_pattern             = var.subscription_filter_pattern
}
