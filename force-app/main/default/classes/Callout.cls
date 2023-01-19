/**
 * Created by Yury Nistratau on 09.01.2023.
 */

public with sharing abstract class Callout {

    protected String endPointURL;
    protected String httpMethod;
    protected Map<String, String> mapHeader = new Map<String, String>();
    protected Map<String, String> secureMap = new Map<String, String>();

    public abstract Type getType();
    public abstract String buildRequestBody();
    public abstract Object parseResponse(String responseStr);

    public HttpRequest buildHttpRequest() {
        HttpRequest httpRequest = new HttpRequest();
        String requestBody = buildRequestBody();
        httpRequest.setEndpoint(endPointURL);
        httpRequest.setMethod(httpMethod);
        httpRequest.setTimeout(120000);
        if (mapHeader != null && mapHeader.size() > 0) {
            for (String key : mapHeader.keySet()) {
                String val = mapHeader.get(key);
                httpRequest.setHeader(key, val);
            }
        }
        if (requestBody != null) httpRequest.setBody(replaceProtectedParameters(requestBody));
        return httpRequest;
    }

    private String replaceProtectedParameters(String requestBody) {
        for (String key : secureMap.keySet()) {
            String val = secureMap.get(key);
            requestBody = requestBody.replace(key, val);
        }
        return requestBody;
    }
}
