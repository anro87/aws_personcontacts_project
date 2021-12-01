const aws_config = {
    aws_project_region: process.env.REACT_APP_AWS_REGION,
    aws_cognito_region: process.env.REACT_APP_AWS_REGION,
    aws_user_pools_id: process.env.REACT_APP_COGNITO_USER_POOL_ID,
    aws_user_pools_web_client_id: process.env.REACT_APP_COGNITO_APP_CLIENT_ID,
    aws_api_gateway: process.env.REACT_APP_API_GW_URL,
    oauth: {},
};

export default aws_config;