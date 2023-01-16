/**
 * Created by Yury Nistratau on 09.01.2023.
 */

public with sharing class CalloutExecutor {

    public Object execute(Callout callout) {
        HttpResponse httpResponse = new HttpResponse();
        Long startCallout;
        Long finishCallout;
        try {
            Http http = new Http();
            startCallout = System.currentTimeMillis();
            httpResponse = http.send(callout.httpRequest);
            finishCallout = System.currentTimeMillis();

            callout.integrationLog.Callout_Duration__c = finishCallout - startCallout;
            callout.integrationLog.Callout_Class__c = callout.getType().getName();
            callout.integrationLog.Request_Body__c = callout.httpRequest.getBody();
            callout.integrationLog.Response_Body__c = httpResponse.getBody();
            callout.integrationLog.Response_Status_Code__c = httpResponse.getStatusCode();
            callout.integrationLog.Endpoint_URL__c = callout.httpRequest.getEndpoint();
            callout.integrationLog.Error_Message__c = '';
            callout.integrationLog.Success__c = true;
            return callout.parseResponse(httpResponse.getBody());
        } catch (CalloutException e) {
            callout.integrationLog.Callout_Duration__c = finishCallout - startCallout;
            callout.integrationLog.Callout_Class__c = callout.getType().getName();
            callout.integrationLog.Request_Body__c = callout.httpRequest.getBody();
            callout.integrationLog.Response_Body__c = httpResponse.getBody();
            callout.integrationLog.Response_Status_Code__c = httpResponse.getStatusCode();
            callout.integrationLog.Endpoint_URL__c = callout.httpRequest.getEndpoint();
            callout.integrationLog.Error_Message__c = e.getMessage();
            callout.integrationLog.Success__c = false;
            return e.getMessage();
        }
    }
}