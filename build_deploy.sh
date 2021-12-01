#!/bin/bash

#Build Java Lambda
cd lambdas/readDynamoDB
mvn clean install
cd ../..

#Install Node.JS Lambda Dependencies
cd lambdas/writeDynamoDB
npm install
cd ../..

#Deploy infrastructure
terraform init
if terraform apply -auto-approve
then
    # Build website
    export COGNITO_USER_POOL_ID=$(terraform output --raw cognito-user-pool-id)
    export COGNITO_APP_CLIENT_ID=$(terraform output --raw cognito-app-client-id)
    export AWS_REGION=$(terraform output --raw aws_region)
    export API_GW_URL=$(terraform output --raw api-gateway)
    cd web
    npm install
    npm run build
    # Deploy website
    terraform init
    terraform apply -auto-approve
    export APP_URL=$(terraform output --raw bucket_domain_name)
fi

echo $COGNITO_USER_POOL_ID
echo $COGNITO_APP_CLIENT_ID
echo $AWS_REGION
echo $API_GW_URL

open "http://${APP_URL}/signin"


