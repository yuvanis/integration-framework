/**
 * Created by Yury Nistratau on 10.01.2023.
 */

public with sharing class CalloutGetSessionId extends Callout {

    private String username;
    private String password;
    private String securityToken;

    public CalloutGetSessionId(String username, String password, String securityToken) {

        this.username = username;
        this.password = password;
        this.securityToken = securityToken;
        if (this.securityToken == null) this.securityToken = '';

        this.httpRequest.setMethod('POST');
        this.httpRequest.setEndpoint('https://login.salesforce.com/services/Soap/c/56.0');
        this.httpRequest.setTimeout(120000);
//        Map<String, String> mapHeader = new Map<String, String>{
//                'Connection' => 'Keep-Alive',
//                'Content-Type' => 'text/xml;charset=UTF-8',
//                'SOAPAction' => 'login',
//                'Content-Length' => '410'
//        };
        this.httpRequest.setHeader('Connection', 'Keep-Alive');
        this.httpRequest.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        this.httpRequest.setHeader('SOAPAction', 'login');
        this.httpRequest.setHeader('Content-Length', '410');

        this.httpRequest.setBody(buildRequestBody());
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
                            '<urn:username>' + this.username + '</urn:username>' +
                            '<urn:password>' + this.password + this.securityToken + '</urn:password>' +
                        '</urn:login>' +
                    '</soapenv:Body>' +
               '</soapenv:Envelope>';
    }

    public override Object parseResponse(String responseStr) {
        Dom.Document document = new Dom.Document();
        document.load(responseStr);
        String soapenv = 'http://schemas.xmlsoap.org/soap/envelope/';
        String urn = 'urn:enterprise.soap.sforce.com';
        String sessionId = (String)document.getRootElement().
                getChildElement('Body', soapenv).
                getChildElement('loginResponse', urn).
                getChildElement('result', urn).
                getChildElement('sessionId', urn).getText();
        return sessionId;
    }
}