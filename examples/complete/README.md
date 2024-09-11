# complete

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.66.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 1.0 |
| <a name="module_cloudwatch_log_group_wrapper"></a> [cloudwatch\_log\_group\_wrapper](#module\_cloudwatch\_log\_group\_wrapper) | ../.. | n/a |
| <a name="module_firehose_delivery_stream"></a> [firehose\_delivery\_stream](#module\_firehose\_delivery\_stream) | terraform.registry.launch.nttdata.com/module_primitive/firehose_delivery_stream/aws | ~> 1.0 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform.registry.launch.nttdata.com/module_collection/s3_bucket/aws | ~> 1.0 |
| <a name="module_producer_role"></a> [producer\_role](#module\_producer\_role) | terraform.registry.launch.nttdata.com/module_collection/iam_assumable_role/aws | ~> 1.0.0 |
| <a name="module_consumer_role"></a> [consumer\_role](#module\_consumer\_role) | terraform.registry.launch.nttdata.com/module_collection/iam_assumable_role/aws | ~> 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.consumer_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.producer_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"backend"` | no |
| <a name="input_create_cloudwatch_log_stream"></a> [create\_cloudwatch\_log\_stream](#input\_create\_cloudwatch\_log\_stream) | Flag to indicte if AWS cloudwatch log stream needs to be created. | `bool` | `false` | no |
| <a name="input_create_cloudwatch_log_subscription_filter"></a> [create\_cloudwatch\_log\_subscription\_filter](#input\_create\_cloudwatch\_log\_subscription\_filter) | Flag to indicte if  AWS cloudwatch log subscription filter needs to be created. | `bool` | `false` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | (Required) Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | `"dev"` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object(<br>    {<br>      name       = string<br>      max_length = optional(number, 60)<br>    }<br>  ))</pre> | <pre>{<br>  "consumer_policy": {<br>    "max_length": 60,<br>    "name": "csmplcy"<br>  },<br>  "consumer_role": {<br>    "max_length": 60,<br>    "name": "csmrole"<br>  },<br>  "delivery_stream": {<br>    "max_length": 63,<br>    "name": "ds"<br>  },<br>  "log_group": {<br>    "max_length": 63,<br>    "name": "lg"<br>  },<br>  "log_stream": {<br>    "max_length": 63,<br>    "name": "ls"<br>  },<br>  "producer_policy": {<br>    "max_length": 63,<br>    "name": "pdcplcy"<br>  },<br>  "producer_role": {<br>    "max_length": 63,<br>    "name": "pdcrole"<br>  },<br>  "subscription_filter": {<br>    "max_length": 63,<br>    "name": "subfltr"<br>  }<br>}</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | (Required) The location where the resource will be created. Must not have spaces<br>    For example, us-east-1, us-west-2, eu-west-1, etc. | `string` | `"us-east-2"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the resource should be provisioned like dev, qa, prod etc. | `string` | `"dev"` | no |
| <a name="input_environment_number"></a> [environment\_number](#input\_environment\_number) | The environment count for the respective environment. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_resource_number"></a> [resource\_number](#input\_resource\_number) | The resource count for the respective resource. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_http_endpoint_url"></a> [http\_endpoint\_url](#input\_http\_endpoint\_url) | URL to which the Delivery Stream should deliver its records. | `string` | n/a | yes |
| <a name="input_http_endpoint_name"></a> [http\_endpoint\_name](#input\_http\_endpoint\_name) | Friendly name for the HTTP endpoint associated with this Delivery Stream. | `string` | n/a | yes |
| <a name="input_s3_error_prefix"></a> [s3\_error\_prefix](#input\_s3\_error\_prefix) | Prefix to prepend to failed records being sent to S3. Ensure this value contains a trailing slash if set to anything other than an empty string. | `string` | `""` | no |
| <a name="input_producer_external_id"></a> [producer\_external\_id](#input\_producer\_external\_id) | STS External ID used for the assumption policy when creating the producer role. | `list(string)` | `null` | no |
| <a name="input_producer_trusted_service"></a> [producer\_trusted\_service](#input\_producer\_trusted\_service) | Trusted service used for the assumption policy when creating the producer role. Defaults to the logs service for the current AWS region. | `string` | `null` | no |
| <a name="input_consumer_trusted_services"></a> [consumer\_trusted\_services](#input\_consumer\_trusted\_services) | Trusted service used for the assumption policy when creating the consumer role. Defaults to the firehose service. | `string` | `null` | no |
| <a name="input_consumer_external_id"></a> [consumer\_external\_id](#input\_consumer\_external\_id) | STS External ID used for the assumption policy when creating the consumer role. Defaults to the current AWS account ID. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#output\_cloudwatch\_log\_group\_arn) | ARN of the cloudwatch log group. |
| <a name="output_cloudwatch_log_stream_arn"></a> [cloudwatch\_log\_stream\_arn](#output\_cloudwatch\_log\_stream\_arn) | ARN of the cloudwatch log stream. |
| <a name="output_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#output\_cloudwatch\_log\_group\_name) | Name of the cloudwatch log group. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
