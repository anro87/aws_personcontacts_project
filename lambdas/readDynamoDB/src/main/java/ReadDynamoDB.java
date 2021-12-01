import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.*;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;

import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPResponse;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dto.Contact;
import dto.User;

import java.util.*;


// Handler value: example.HandlerDynamoDB
public class ReadDynamoDB implements RequestHandler<APIGatewayV2HTTPEvent, APIGatewayV2HTTPResponse>{
    Gson gson = new GsonBuilder().setPrettyPrinting().create();

    static AmazonDynamoDB client = AmazonDynamoDBClientBuilder.standard().build();
    static DynamoDB dynamoDB = new DynamoDB(client);
    private String DYNAMODB_TABLE_NAME = "LambdaDataPush";
    private LambdaLogger logger;
    private String userid;

    @Override
    public APIGatewayV2HTTPResponse handleRequest(APIGatewayV2HTTPEvent event, Context context)
    {
        logger = context.getLogger();
        logger.log("Successfully executed. Input: " + gson.toJson(event.getQueryStringParameters()));

        APIGatewayV2HTTPResponse response = new APIGatewayV2HTTPResponse();
        response.setIsBase64Encoded(false);

        HashMap<String, String> headers = new HashMap<String, String>();
        headers.put("Content-Type", "application/json");
        response.setHeaders(headers);

        if(event.getQueryStringParameters() == null || !event.getQueryStringParameters().containsKey("userid")){
            response.setStatusCode(400);
            response.setBody("{\"message\":\"userid missing\"}");
            return response;
        }

        userid = event.getQueryStringParameters().get("userid");

        try{
            response.setStatusCode(200);
            response.setBody(gson.toJson(readRecords(userid)));
        } catch (Exception e) {
            logger.log("GetItem failed.");
            logger.log(e.getMessage());
            response.setStatusCode(500);
            response.setBody("{\"message\":\"internal error\"}");
        }
        return response;
    }

    private List<Contact> readRecords(String userid){
        Table table = dynamoDB.getTable(DYNAMODB_TABLE_NAME);
        ItemCollection<QueryOutcome> items = table.query("userid", userid);

        Iterator<Item> iterator = items.iterator();
        List<Contact> result = new ArrayList<>();
        while (iterator.hasNext()) {
            Item item = iterator.next();
            logger.log("Fetched data: " + item.toJSONPretty());
            User user = gson.fromJson(item.toJSON(), User.class);
            result.add(user.contact);
        }
        return result;
    }
}