# AWS Sample Playground Project
Sample Playground project using Terraform, AWS Lambda, AWS API Gateway, DynamoDB &amp; ReactJS.

It basically provides the user with a website to register via email and password. Once registered a login is possible and the user can save contacts connected to his email address. The website is based on ReactJS.

**Please note that this project is was only developed as a playground and is not providing guidance on the right architecture. For instance the public expose of a webpage directly via S3 is not advice for productive purpose.**

# Prerequisites to run the project
* Node.js
* Install ReactJS module with npm `npm i react-scripts`
* Maven
* Java
* Terraform

# Execute the project
* Deploy the environment on AWS: `sh build_deploy.sh`
* Destroy the environment on AWS: `sh destroy.sh`

# Architecture
![ArchitectureSampleProjectAWS](https://user-images.githubusercontent.com/36228512/144240374-5c84176f-b933-41b0-8458-dd0c0e42af74.jpg)

