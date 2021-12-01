package dto;

import com.amazonaws.services.dynamodbv2.document.Item;

public class User extends Item {
    public String userid;
    public String contactid;
    public Contact contact;
}
