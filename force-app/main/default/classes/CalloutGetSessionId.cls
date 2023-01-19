/**
 * Created by Yury Nistratau on 10.01.2023.
 */

public with sharing class CalloutGetSessionId extends Callout {

    private final String USERNAME;
    private final String PASSWORD;

    private String securityToken;

    public CalloutGetSessionId(String username, String password, String securityToken) {
        this.USERNAME = username;
        this.PASSWORD = password;
        this.securityToken = securityToken;
        if (this.securityToken == null) this.securityToken = '';
        this.endPointURL = 'callout:SalesforceLogin';
        this.httpMethod = HTTP_METHOD_POST;
        this.mapHeader.putAll(new Map<String, String>{
                'Connection' => 'Keep-Alive',
                'Content-Type' => 'text/xml;charset=UTF-8',
                'SOAPAction' => 'login',
                'Content-Length' => '410'
        });
        this.secureMap.putAll(new Map<String, String> {
                'secureUsername' => this.USERNAME,
                'securePassword' => this.PASSWORD,
                'securityToken' => this.securityToken
        });
    }

    public override Type getType() {
        return CalloutGetSessionId.class;
    }

    public override String buildRequestBody() {
        return '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:enterprise.soap.sforce.com">' +
                '<soapenv:Header>' +
                '</soapenv:Header>' +
                '<soapenv:Body>' +
                '<urn:login>' +
                '<urn:username>secureUsername</urn:username>' +
                '<urn:password>securePasswordsecurityToken</urn:password>' +
                '</urn:login>' +
                '</soapenv:Body>' +
                '</soapenv:Envelope>';
    }

    public override Object parseResponse(String responseStr) {
        Dom.Document document = new Dom.Document();
        document.load(responseStr);
        String soapenv = 'http://schemas.xmlsoap.org/soap/envelope/';
        String urn = 'urn:enterprise.soap.sforce.com';
        String sessionId = (String) document.getRootElement().
                getChildElement('Body', soapenv).
                getChildElement('loginResponse', urn).
                getChildElement('result', urn).
                getChildElement('sessionId', urn).getText();
        return sessionId;
    }
}
