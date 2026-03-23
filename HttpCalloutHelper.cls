public with sharing class HttpCalloutHelper {

    public static HttpResponse sendRequest(String endpoint, String method, Map<String, String> headers, String body) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod(method);
        req.setTimeout(120000);

        if (headers != null) {
            for (String key : headers.keySet()) {
                req.setHeader(key, headers.get(key));
            }
        }
        if (String.isNotBlank(body)) {
            req.setBody(body);
        }

        Http http = new Http();
        return http.send(req);
    }

    public static HttpResponse doGet(String endpoint, String token) {
        Map<String, String> headers = new Map<String, String>{
            'Authorization' => 'Bearer ' + token,
            'Content-Type' => 'application/json'
        };
        return sendRequest(endpoint, 'GET', headers, null);
    }

    public static HttpResponse doPost(String endpoint, String token, String body) {
        Map<String, String> headers = new Map<String, String>{
            'Authorization' => 'Bearer ' + token,
            'Content-Type' => 'application/json'
        };
        return sendRequest(endpoint, 'POST', headers, body);
    }
}
