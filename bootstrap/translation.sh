#!/bin/bash

# Setup environment variables
AWS_REGION=$(aws configure get region)

cd ../backend/translation/local-app/
npm install
node ./translate.js $AWS_REGION

# Copy the output file to the frontend app
cp ./translations.json ../../../frontend/src/languages/
cd ../../../frontend/src/languages/
