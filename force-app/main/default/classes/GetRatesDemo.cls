/**
 * Created by Yury Nistratau on 05.01.2023.
 */

public with sharing class GetRatesDemo {

    public String execute() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.floatrates.com/daily/usd.json');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        return response.getBody();
    }
}