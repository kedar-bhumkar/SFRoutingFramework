@isTest
public with sharing class HttpCalloutHelperTest {

    private class MockHttpResponse implements HttpCalloutMock {
        private Integer statusCode;
        private String body;

        public MockHttpResponse(Integer statusCode, String body) {
            this.statusCode = statusCode;
            this.body = body;
        }

        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(this.statusCode);
            res.setBody(this.body);
            return res;
        }
    }

    @isTest
    static void testSendRequest() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(200, '{"status":"ok"}'));

        Map<String, String> headers = new Map<String, String>{
            'Content-Type' => 'application/json'
        };

        Test.startTest();
        HttpResponse res = HttpCalloutHelper.sendRequest('https://example.com/api', 'POST', headers, '{"name":"test"}');
        Test.stopTest();

        System.assertEquals(200, res.getStatusCode());
        System.assertEquals('{"status":"ok"}', res.getBody());
    }

    @isTest
    static void testSendRequestNullHeadersAndBody() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(200, 'OK'));

        Test.startTest();
        HttpResponse res = HttpCalloutHelper.sendRequest('https://example.com/api', 'GET', null, null);
        Test.stopTest();

        System.assertEquals(200, res.getStatusCode());
    }

    @isTest
    static void testDoGet() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(200, '{"id":"123"}'));

        Test.startTest();
        HttpResponse res = HttpCalloutHelper.doGet('https://example.com/api/record', 'test-token');
        Test.stopTest();

        System.assertEquals(200, res.getStatusCode());
    }

    @isTest
    static void testDoPost() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(201, '{"id":"456"}'));

        Test.startTest();
        HttpResponse res = HttpCalloutHelper.doPost('https://example.com/api/record', 'test-token', '{"name":"new"}');
        Test.stopTest();

        System.assertEquals(201, res.getStatusCode());
    }

    @isTest
    static void testSendRequestError() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(500, 'Internal Server Error'));

        Test.startTest();
        HttpResponse res = HttpCalloutHelper.sendRequest('https://example.com/api', 'GET', null, null);
        Test.stopTest();

        System.assertEquals(500, res.getStatusCode());
    }
}
