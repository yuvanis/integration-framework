/**
 * Created by Yury Nistratau on 09.01.2023.
 */

@IsTest
private class CalloutExecutorTest {

    @IsTest
    static void testCalloutGetSessionIdPositive() {
        String responseBody = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="urn:enterprise.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><loginResponse><result><metadataServerUrl>https://wise-narwhal-rpac63-dev-ed.trailblaze.my.salesforce.com/services/Soap/m/56.0/00D2w00000JaEQ9</metadataServerUrl><passwordExpired>false</passwordExpired><sandbox>false</sandbox><serverUrl>https://wise-narwhal-rpac63-dev-ed.trailblaze.my.salesforce.com/services/Soap/c/56.0/00D2w00000JaEQ9</serverUrl><sessionId>SESSION_ID_REMOVED</sessionId><userId>0052w00000BZZx6AAH</userId><userInfo><accessibilityMode>false</accessibilityMode><chatterExternal>false</chatterExternal><currencySymbol xsi:nil="true"/><orgAttachmentFileSizeLimit>26214400</orgAttachmentFileSizeLimit><orgDefaultCurrencyIsoCode xsi:nil="true"/><orgDefaultCurrencyLocale xsi:nil="true"/><orgDisallowHtmlAttachments>false</orgDisallowHtmlAttachments><orgHasPersonAccounts>false</orgHasPersonAccounts><organizationId>00D2w00000JaEQ9EAN</organizationId><organizationMultiCurrency>true</organizationMultiCurrency><organizationName>Personal</organizationName><profileId>00e2w000003tRbYAAU</profileId><roleId>00E2w000002LxYoEAK</roleId><sessionSecondsValid>7200</sessionSecondsValid><userDefaultCurrencyIsoCode>USD</userDefaultCurrencyIsoCode><userId>0052w00000BZZx6AAH</userId><userLanguage>en_US</userLanguage><userLocale>en_US</userLocale><userType>Standard</userType><userUiSkin>Theme3</userUiSkin></userInfo></result></loginResponse></soapenv:Body></soapenv:Envelope>';
        HTTPMockFactory mock = new HTTPMockFactory(200, 'OK', responseBody, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        String sessionId = (String) CalloutExecutor.execute(new CalloutGetSessionId('testName', 'testPassword', 'testSecurityToken'));
        Integration_Log__c log = [SELECT Endpoint_URL__c, Success__c FROM Integration_Log__c];
        Test.stopTest();
        System.assertEquals(sessionId, 'SESSION_ID_REMOVED');
        System.assertEquals('callout:SalesforceLogin', log.Endpoint_URL__c);
        System.assertEquals(true, log.Success__c);
    }

    @IsTest
    static void testCalloutGetSessionIdNegative() {
        String responseBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sf="urn:fault.enterprise.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
                '<soapenv:Body>' +
                '<soapenv:Fault>' +
                '<faultcode>sf:INVALID_LOGIN</faultcode>' +
                '<faultstring>INVALID_LOGIN: Invalid username, password, security token; or user locked out.</faultstring>' +
                '<detail>' +
                '<sf:LoginFault xsi:type="sf:LoginFault">' +
                '<sf:exceptionCode>INVALID_LOGIN</sf:exceptionCode>' +
                '<sf:exceptionMessage>Invalid username, password, security token; or user locked out.</sf:exceptionMessage>' +
                '</sf:LoginFault>' +
                '</detail>' +
                '</soapenv:Fault>' +
                '</soapenv:Body>' +
                '</soapenv:Envelope>';
        HTTPMockFactory mock = new HTTPMockFactory(404, 'Not found', responseBody, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        String errorMessage = (String) CalloutExecutor.execute(new CalloutGetSessionId('testName', 'testPass', 'testToken'));
        Integration_Log__c log = [SELECT Error_Message__c, Success__c FROM Integration_Log__c];
        Test.stopTest();
        System.assertEquals(errorMessage, log.Error_Message__c);
        System.assertEquals(false, log.Success__c);
    }

    @IsTest
    static void testCalloutGetRatesPositive() {
        String responseBody = '{"eur":' +
                '{"code":"EUR",' +
                '"alphaCode":"EUR",' +
                '"numericCode":"978",' +
                '"name":"Euro",' +
                '"rate":0.92442362650814,' +
                '"date":"Tue, 17 Jan 2023 23:55:01 GMT",' +
                '"inverseRate":1.0817551297097}}';
        HTTPMockFactory mock = new HTTPMockFactory(200, 'OK', responseBody, new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        Map<String, Decimal> rates = (Map<String, Decimal>) CalloutExecutor.execute(new CalloutGetRates());
        Integration_Log__c log = [SELECT Endpoint_URL__c, Success__c FROM Integration_Log__c];
        Test.stopTest();
        System.assertEquals(rates.get('eur'), 0.92442362650814);
        System.assertEquals('callout:ExchangeRates', log.Endpoint_URL__c);
        System.assertEquals(true, log.Success__c);
    }

    @IsTest
    static void testCalloutGetRatesNegative() {
        HTTPMockFactory mock = new HTTPMockFactory(404, 'Not found', 'Error', new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        String errorMessage = (String) CalloutExecutor.execute(new CalloutGetRates());
        Integration_Log__c log = [SELECT Error_Message__c, Success__c FROM Integration_Log__c];
        Test.stopTest();
        System.assertEquals(errorMessage, log.Error_Message__c);
        System.assertEquals(false, log.Success__c);
    }

}
