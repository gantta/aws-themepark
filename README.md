# aws-themepark
Innovator Island Amplify Theme Park

[Referenced from AWS re:Invent Workshop session](https://www.eventbox.dev/published/lesson/innovator-island/)

### Tech Stack
[AWS](https://console.aws.amazon.com) | [AWS Amplify Framework](https://docs.amplify.aws/cli/start/install) | [AWS Serverless Application Model](https://aws.amazon.com/serverless/sam/)

## Getting Started with AWS Amplify Framework

* Install the latest Amplify CLI version
    `npm install -g @aws-amplify/cli`
* Follow this [guide](https://docs.amplify.aws/cli/start/install#configure-the-amplify-cli) to configure Amplify
* Configuration of VueJs app located in `frontend` dir. 
* Create a new Amplify host web app using the `amplify.yml` build settings.

## Getting Started with AWS Serverless Application Model (SAM)

* Install the latest SAM CLI following the installation [guide](https://aws.amazon.com/serverless/sam/)
* Change directory to `cd bootsrap`
* Prep your environment with the `./bootstrap.sh` script
    NOTE: This script is assuming an Ubuntu linux distribution
* Setup the backend resources with the `./setup-backend.sh` script
* Copy the API Endpoint provided in the last line of the output
  Should be similar to `https://glkvjnngck.execute-api.us-east-2.amazonaws.com/Prod/InitState/`

## Update the front end

* Update the `frontend/src/config.js` file `initStateAPI` value to match the new API URL

