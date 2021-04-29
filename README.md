# aws-themepark
Innovator Island Amplify Theme Park

[Referenced from AWS re:Invent Workshop session](https://www.eventbox.dev/published/lesson/innovator-island/)

### Tech Stack
[AWS](https://console.aws.amazon.com) | [AWS Amplify Framework](https://docs.amplify.aws/cli/start/install) | [AWS Serverless Application Model](https://aws.amazon.com/serverless/sam/)

## Getting Started with AWS Amplify Framework

1. Install the latest Amplify CLI version
    `npm install -g @aws-amplify/cli`
2. Follow this [guide](https://docs.amplify.aws/cli/start/install#configure-the-amplify-cli) to configure Amplify
3. Configuration of VueJs app located in `frontend` dir. 
4. Create a new Amplify host web app using the `amplify.yml` build settings.

## Getting Started with AWS Serverless Application Model (SAM)

1. Install the latest SAM CLI following the installation [guide](https://aws.amazon.com/serverless/sam/)
2. Change directory to `cd bootsrap`
3. Prep your environment with the `./bootstrap.sh` script
    NOTE: This script is assuming an Ubuntu linux distribution
4. Setup the backend resources with the `./setup-backend.sh` script
5. Copy the API Endpoint provided in the last line of the output
  Should be similar to `https://glkvjnngck.execute-api.us-east-2.amazonaws.com/Prod/InitState/`
6. Update the `frontend/src/config.js` file `initStateAPI` value to match the new API URL

## Add Real-time Messaging
1. Change directory to `cd bootsrap`
2. Add the new Lambda function with the `./messaging.sh` script
3. Note the three output variables from the script:
```
    Cognito Pool: us-east-2:adebd190-8590-47e7-9c0b-15ff289e50d6
    IOT Endpoint: a1c4z5dui0bt0v-ats.iot.us-east-2.amazonaws.com
    AWS Region: us-east-2
```
4. Update the `frontend/src/config.js` file setting the `iot` values to match the results from the output

## Add Chromakey Lambda Function
1. Change directory to `cd ./backend/photos/1-chromakey/`
2. Add the new lambda function with the `./chromakey.sh` script
3. Note the upload bucket output from the script
4. Test the upload `aws s3 cp ./green-screen-test.png s3://youruploadbucketname`
5. In the AWS console, navigate to the S3 service and select the `theme-park-backend-processingbucket` bucket
6. Download and view the `green-screen-test.png` object

## Add Composite Processing Lambda Function
1. Change directory to `cd ./backend/photos/2-processing/`
2. Add the new lambda function with the `./processing.sh` script
3. Note the upload bucket output from the script
4. Test the upload `aws s3 cp ./green-screen-test.png s3://youruploadbucketname`
5. In the AWS console, navigate to the S3 service and select the `theme-park-backend-finalbucket` bucket
6. Download and view the `green-screen-test.jpg` object

## Add Post Processing Lambda Function
1. Change directory to `cd ./backend/photos/3-postprocessing/`
2. Add the new lambda function with the `./postprocessing.sh` script
3. Note the photo upload URL output from the script
4. Update the `frontend/src/config.js` file setting the `photoUploadURL` value to match the results from the output

## Add Translation
1. Change directory to `cd ./bootstrap/`
2. Run the local translation app with the `