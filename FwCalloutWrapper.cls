public with sharing class FwCalloutWrapper {
    public class CalloutRequest {
        public String serviceName {get;set;}
        public String endpoint {get;set;}
        public String method {get;set;}
        public String body {get;set;}
        public Map<String, String> headers {get;set;}
    }

    public class CalloutResponse {
        public Integer statusCode {get;set;}
        public String responseBody {get;set;}
        public Boolean isSuccess {get;set;}
    }
}
