package testimpl

import (
	"context"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/cloudwatchlogs"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestCloudWatchLogsComplete(t *testing.T, ctx types.TestContext) {
	t.Run("TestARNPatternMatches", func(t *testing.T) {
		checkARNFormat(t, ctx)
	})

	t.Run("TestingLogGroup", func(t *testing.T) {
		checkLogGroup(t, ctx)
	})

	t.Run("TestingLogStream", func(t *testing.T) {
		checkLogStream(t, ctx)
	})
}

func checkARNFormat(t *testing.T, ctx types.TestContext) {
	expectedGroupPatternARN := "^arn:aws:logs:[a-z0-9-]+:[0-9]{12}:log-group:[a-zA-Z0-9-]+$"
	expectedStreamPatternARN := "^arn:aws:logs:[a-z0-9-]+:[0-9]{12}:log-group:[a-zA-Z0-9-]+:log-stream:[a-zA-Z0-9-]+$"

	actualGroupARN := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudwatch_log_group_arn")
	assert.NotEmpty(t, actualGroupARN, "ARN is empty")
	assert.Regexp(t, expectedGroupPatternARN, strings.Trim(actualGroupARN, "[]"), "Group ARN does not match expected pattern")

	actualStreamARN := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudwatch_log_stream_arn")
	assert.NotEmpty(t, actualStreamARN, "ARN is empty")
	assert.Regexp(t, expectedStreamPatternARN, strings.Trim(actualStreamARN, "[]"), "Stream ARN does not match expected pattern")
}

func checkLogGroup(t *testing.T, ctx types.TestContext) {
	client := GetCloudWatchClient(t)
	expectedName := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudwatch_log_group_name")

	input := &cloudwatchlogs.DescribeLogGroupsInput{
		LogGroupNamePrefix: aws.String(strings.Trim(expectedName, "[]")),
	}

	output, err := client.DescribeLogGroups(context.TODO(), input)
	assert.NoError(t, err, "Failed to retrieve log group from AWS")

	currentName := output.LogGroups[0].LogGroupName
	assert.Equal(t, strings.Trim(expectedName, "[]"), *currentName, "Log group name doesn't match")
}

func checkLogStream(t *testing.T, ctx types.TestContext) {
	client := GetCloudWatchClient(t)
	groupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudwatch_log_group_name")
	expectedName := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudwatch_log_stream_name")

	input := &cloudwatchlogs.DescribeLogStreamsInput{
		LogGroupName: aws.String(strings.Trim(groupName, "[]")),
	}

	output, err := client.DescribeLogStreams(context.TODO(), input)
	assert.NoError(t, err, "Failed to retrieve log stream from AWS")

	currentName := *output.LogStreams[0].LogStreamName
	assert.Equal(t, strings.Trim(expectedName, "[]"), currentName, "Log stream name doesn't match")
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}

func GetCloudWatchClient(t *testing.T) *cloudwatchlogs.Client {
	cloudwatchClient := cloudwatchlogs.NewFromConfig(GetAWSConfig(t))
	return cloudwatchClient
}
