#!/bin/bash

# Setup environment variables
AWS_REGION=$(aws configure get region)
accountId=$(aws sts get-caller-identity | jq -r .Account)
s3_deploy_bucket="sam-theme-park-deploys-${accountId}"
FINAL_BUCKET=$(aws cloudformation describe-stack-resource --stack-name theme-park-backend --logical-resource-id FinalBucket --query "StackResourceDetail.PhysicalResourceId" --output text)
PROCESSING_BUCKET=$(aws cloudformation describe-stack-resource --stack-name theme-park-backend --logical-resource-id ProcessingBucket --query "StackResourceDetail.PhysicalResourceId" --output text)
UPLOAD_BUCKET=$(aws cloudformation describe-stack-resource --stack-name theme-park-backend --logical-resource-id UploadBucket --query "StackResourceDetail.PhysicalResourceId" --output text)

##Create the Lambda function using SAM
sam build
sam package --output-template-file packaged.yaml --s3-bucket $s3_deploy_bucket
sam deploy --template-file packaged.yaml --stack-name theme-park-photos --capabilities CAPABILITY_IAM --parameter-overrides "FinalBucketName"=$FINAL_BUCKET

##Adding the S3 trigger

COMPOSITE_FUNCTION=$(aws cloudformation describe-stack-resource --stack-name theme-park-photos --logical-resource-id CompositeFunction --query "StackResourceDetail.PhysicalResourceId" --output text)

aws lambda add-permission --function-name $COMPOSITE_FUNCTION --action lambda:InvokeFunction --statement-id s3-to-lambda-composite --principal s3.amazonaws.com --source-arn "arn:aws:s3:::$PROCESSING_BUCKET" --source-account $accountId

COMPOSITE_FUNCTION_ARN=$(aws lambda get-function --function-name $COMPOSITE_FUNCTION | grep FunctionArn | cut -d'"' -f 4)
PROCESSING_NOTIFICATION_CONFIGURATION='{"LambdaFunctionConfigurations":[{"Id":"'$COMPOSITE_FUNCTION'-event","LambdaFunctionArn":"'$COMPOSITE_FUNCTION_ARN'","Events": ["s3:ObjectCreated:*"]}]}'
aws s3api put-bucket-notification-configuration --bucket $PROCESSING_BUCKET --notification-configuration "$PROCESSING_NOTIFICATION_CONFIGURATION"

echo "Upload bucket: "$UPLOAD_BUCKET