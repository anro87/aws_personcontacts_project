var AWS = require('aws-sdk');
var random_name = require('node-random-name');
var dynamo = new AWS.DynamoDB.DocumentClient();

module.exports.handler = async (event) => {
  console.log('Event: ', event);

  if(event.queryStringParameters === null || event.queryStringParameters.userid === null){
    console.error('UserId missing in request');
    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        message: 'Missing userId in request',
      }),
    }
  }

  const params = {
    TableName: 'LambdaDataPush',
    Item: {
      userid: event.queryStringParameters.userid,
      contactid: random_name(),
      contact: JSON.parse(event.body)
    }
  };

  try {
    const result = await dynamo.put(params).promise();
    console.log('great success!', result);

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(params)
    }
  } catch (err) {
    console.log('Error putting item into dynamodb failed: ' + err);
    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        message: err,
      }),
    }
  }
};