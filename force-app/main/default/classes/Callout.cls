/**
 * Created by Yury Nistratau on 09.01.2023.
 */

public with sharing abstract class Callout {

    public HttpRequest httpRequest = new HttpRequest();
    public Integration_Log__c integrationLog = new Integration_Log__c();

    public abstract Type getType();
    public abstract String buildRequestBody();
    public abstract Object parseResponse(String responseStr);
}