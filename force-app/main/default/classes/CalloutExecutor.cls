/**
 * Created by Yury Nistratau on 09.01.2023.
 */

public with sharing class CalloutExecutor {

    private static String replaceProtectedParameters(String requestBody, Map<String, String> secureMap) {
        for (String key : secureMap.keySet()) {
            String val = secureMap.get(key);
            requestBody = requestBody.replace(key, val);
        }
        return requestBody;
    }

    public static Object execute(Callout callout) {
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint(callout.endPointURL);
        httpRequest.setMethod(callout.httpMethod);
        httpRequest.setTimeout(callout.timeout);
        if (callout.mapHeader != null && callout.mapHeader.size() > 0) {
            for (String key : callout.mapHeader.keySet()) {
                String val = callout.mapHeader.get(key);
                httpRequest.setHeader(key, val);
            }
        }
        if (callout.buildRequestBody() != null) {
            httpRequest.setBody(replaceProtectedParameters(callout.buildRequestBody(), callout.secureMap));
        }
        HttpResponse httpResponse = new HttpResponse();
        Http http = new Http();
        Integration_Log__c integrationLog = new Integration_Log__c();
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
