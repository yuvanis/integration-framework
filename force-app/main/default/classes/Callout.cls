/**
 * Created by Yury Nistratau on 09.01.2023.
 */

public with sharing abstract class Callout {

    public String endPointURL;
    public String httpMethod;
    public Integer timeout = 120000;
    public Map<String, String> mapHeader = new Map<String, String>();
    public Map<String, String> secureMap = new Map<String, String>();

    public abstract Type getType();
    public abstract String buildRequestBody();
    public abstract Object parseResponse(String responseStr);
}