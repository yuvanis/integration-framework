/**
 * Created by Yury Nistratau on 09.01.2023.
 */

public with sharing class CalloutExecutor {

    public static Object execute(Callout callout) {

        HttpResponse httpResponse = new HttpResponse();
        Http http = new Http();
        Integration_Log__c integrationLog = new Integration_Log__c();
        HttpRequest httpRequest = callout.buildHttpRequest();
        Long startCallout;
        Long finishCallout;
        String errorMessage;
        try {
            startCallout = System.currentTimeMillis();
            httpResponse = http.send(httpRequest);
            finishCallout = System.currentTimeMillis();
            return callout.parseResponse(httpResponse.getBody());
        } catch (Exception e) {
            errorMessage = e.getMessage();
            return errorMessage;
        } finally {
            integrationLog.Callout_Duration__c = finishCallout - startCallout;
            integrationLog.Callout_Class__c = callout.getType().getName();
            integrationLog.Request_Body__c = httpRequest.getBody();
            integrationLog.Response_Body__c = httpResponse.getBody();
            integrationLog.Response_Status_Code__c = httpResponse.getStatusCode();
            integrationLog.Endpoint_URL__c = httpRequest.getEndpoint();
            integrationLog.Error_Message__c = errorMessage;
            integrationLog.Success__c = integrationLog.Error_Message__c != null ? false : true;
            insert integrationLog;
        }
    }
}
