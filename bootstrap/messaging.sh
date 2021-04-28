#!/bin/bash

# Setup environment variables
AWS_REGION=$(aws configure get region)
accountId=$(aws sts get-caller-identity | jq -r .Account)
s3_deploy_bucket="sam-theme-park-deploys-${accountId}"

COGNITO_POOLID=$(aws cognito-identity list-identity-pools  --max-results 10 | grep -B 1 ThemeParkIdentityPool | grep IdentityPoolId | cut -d'"' -f 4)
IOT_ENDPOINT_HOST=$(aws iot describe-endpoint --endpoint-type iot:Data-ATS | grep endpointAddress | cut -d'"' -f 4)
DDB_TABLE=$(aws cloudformation describe-stack-resource --stack-name theme-park-backend --logical-resource-id DynamoDBTable --query "StackResourceDetail.PhysicalResourceId" --output text)

##Create Ridetimes Lambda Function and subscribe to SNS Topic
cd cd ../backend/messaging/
zip messaging-app.zip app.js
LAMBDA_ROLE=$(aws cloudformation describe-stack-resource --stack-name theme-park-backend --logical-resource-id ThemeParkLambdaRole --query "StackResourceDetail.PhysicalResourceId" --output text)
LAMBDA_ROLE_ARN=$(aws iam get-role --role-name $LAMBDA_ROLE | grep Arn | cut -d'"' -f 4)

aws lambda create-function \
    --function-name theme-park-ridetimes \
    --runtime nodejs14.x \
    --zip-file fileb://messaging-app.zip \
    --handler app.handler \
    --role $LAMBDA_ROLE_ARN \
	--environment "Variables={DDB_TABLE_NAME=$DDB_TABLE,IOT_DATA_ENDPOINT=$IOT_ENDPOINT_HOST,IOT_TOPIC=theme-park-rides}"

LAMBDA_RIDE_ARN=$(aws lambda get-function --function-name theme-park-ridetimes | grep FunctionArn | cut -d'"' -f 4)
TOPIC_ARN=$(aws sns list-topics | grep theme-park-ride-times | grep Arn | cut -d'"' -f 4)
aws lambda add-permission --function-name theme-park-ridetimes --action lambda:InvokeFunction --statement-id sns-to-lambda --principal sns.amazonaws.com --source-arn $TOPIC_ARN

echo "Cognito Pool: "$COGNITO_POOLID
echo "IOT Endpoint:" $IOT_ENDPOINT_HOST
echo "AWS Region: "$AWS_REGION
