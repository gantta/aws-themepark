#!/bin/bash

# Setup environment variables
AWS_REGION=$(aws configure get region)
accountId=$(aws sts get-caller-identity | jq -r .Account)
s3_deploy_bucket="sam-theme-park-deploys-${accountId}"
FINAL_BUCKET=$(aws cloudformation describe-stack-resource --stack-name theme-park-backend --logical-resource-id FinalBucket --query "StackResourceDetail.PhysicalResourceId" --output text)
PROCESSING_BUCKET=$(aws cloudformation describe-stack-resource --stack-name theme-park-backend --logical-resource-id ProcessingBucket --query "StackResourceDetail.PhysicalResourceId" --output text)
UPLOAD_BUCKET=$(aws cloudformation describe-stack-resource --stack-name theme-park-backend --logical-resource-id UploadBucket --query "StackResourceDetail.PhysicalResourceId" --output text)

##Creating the Chromakey Lambda function
zip chromakey.zip app.py
LAMBDA_ROLE=$(aws cloudformation describe-stack-resource --stack-name theme-park-backend --logical-resource-id ThemeParkLambdaRole --query "StackResourceDetail.PhysicalResourceId" --output text)
LAMBDA_ROLE_ARN=$(aws iam get-role --role-name $LAMBDA_ROLE | grep Arn | cut -d'"' -f 4)

case $AWS_REGION in
   "us-west-2") LAYER_ARN=arn:aws:lambda:us-west-2:678705476278:layer:Chromakey:1;;
   "us-east-2") LAYER_ARN=arn:aws:lambda:us-east-2:678705476278:layer:Chromakey:1;;
   "us-east-1") LAYER_ARN=arn:aws:lambda:us-east-1:678705476278:layer:Chromakey:1;;
   "eu-central-1") LAYER_ARN=arn:aws:lambda:eu-central-1:678705476278:layer:Chromakey:1;;
   "ap-southeast-2") LAYER_ARN=arn:aws:lambda:ap-southeast-2:678705476278:layer:Chromakey:1;;
   "eu-west-1") LAYER_ARN=arn:aws:lambda:eu-west-1:678705476278:layer:Chromakey:1;;
   *) echo "$AWS_REGION not does have a valid Layer, please use enother Region";;
esac

aws lambda create-function \
    --function-name theme-park-photos-chromakey  \
    --runtime python3.6 \
    --zip-file fileb://chromakey.zip \
    --handler app.lambda_handler \
    --role $LAMBDA_ROLE_ARN \
	--memory-size 3008 \
	--timeout 10 \
	--environment "Variables={OUTPUT_BUCKET_NAME=$PROCESSING_BUCKET,HSV_LOWER='[36, 100, 100]',HSV_UPPER='[70 ,255, 255]'}" \
	--layers $LAYER_ARN

##Adding the S3 trigger

CHROMAKEY_FUNCTION=$(aws lambda get-function --function-name theme-park-photos-chromakey | grep FunctionArn | cut -d'"' -f 4)

aws lambda add-permission --function-name theme-park-photos-chromakey --action lambda:InvokeFunction --statement-id s3-to-lambda-chromakey --principal s3.amazonaws.com --source-arn "arn:aws:s3:::$UPLOAD_BUCKET" --source-account $accountId

CHROMAKEY_FUNCTION_ARN=$(aws lambda get-function --function-name theme-park-photos-chromakey | grep FunctionArn | cut -d'"' -f 4)
CHROMAKEY_NOTIFICATION_CONFIGURATION='{"LambdaFunctionConfigurations":[{"Id":"'theme-park-photos-chromakey'-event","LambdaFunctionArn":"'$CHROMAKEY_FUNCTION_ARN'","Events": ["s3:ObjectCreated:*"]}]}'
aws s3api put-bucket-notification-configuration --bucket $UPLOAD_BUCKET --notification-configuration "$CHROMAKEY_NOTIFICATION_CONFIGURATION"

echo "Upload bucket: "$UPLOAD_BUCKET