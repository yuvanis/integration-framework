/**
 * Created by Yury Nistratau on 09.01.2023.
 */

public with sharing class CalloutGetRates extends Callout {

    public CalloutGetRates() {
        this.httpRequest = new HttpRequest();
        this.httpRequest.setMethod('GET');
        this.httpRequest.setEndpoint('https://www.floatrates.com/daily/usd.json');
    }

    public override Type getType() {
        return CalloutGetRates.class;
    }

    public override String buildRequestBody() {
        return null;
    }

    public override Object parseResponse(String responseStr) {
        return JSON.deserializeUntyped(responseStr);
    }

}