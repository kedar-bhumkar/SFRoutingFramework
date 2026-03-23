@isTest
public with sharing class FwCalloutWrapperTest {

    @isTest
    static void testCalloutRequest() {
        FwCalloutWrapper.CalloutRequest req = new FwCalloutWrapper.CalloutRequest();
        req.serviceName = 'TestService';
        req.endpoint = 'https://example.com/api';
        req.method = 'POST';
        req.body = '{"test":true}';
        req.headers = new Map<String, String>{'Content-Type' => 'application/json'};

        System.assertEquals('TestService', req.serviceName);
        System.assertEquals('POST', req.method);
    }

    @isTest
    static void testCalloutResponse() {
        FwCalloutWrapper.CalloutResponse res = new FwCalloutWrapper.CalloutResponse();
        res.statusCode = 200;
        res.responseBody = '{"id":"123"}';
        res.isSuccess = true;

        System.assertEquals(200, res.statusCode);
        System.assertEquals(true, res.isSuccess);
    }
}
