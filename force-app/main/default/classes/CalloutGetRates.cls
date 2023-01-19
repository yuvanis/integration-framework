/**
 * Created by Yury Nistratau on 09.01.2023.
 */

public with sharing class CalloutGetRates extends Callout {

    public CalloutGetRates() {
        this.endPointURL = 'callout:ExchangeRates';
        this.httpMethod = HTTP_METHOD_GET;
    }

    public override Type getType() {
        return CalloutGetRates.class;
    }

    public override String buildRequestBody() {
        return null;
    }

    public override Object parseResponse(String responseStr) {
        Map<String, Decimal> result = new Map<String, Decimal>();
        Map<String, CalloutGetRates.Rates> rates = (Map<String, CalloutGetRates.Rates>) JSON.deserialize(responseStr, Map<String, CalloutGetRates.Rates>.class);
        for (String key : rates.keySet()) {
            Rates val = rates.get(key);
            result.put(key, val.rate);
        }
        return result;
    }

    public class Rates {
        public Decimal rate;
    }

}
