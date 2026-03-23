@isTest
public with sharing class FwCalloutServiceTest {

    private class MockCalloutResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();

            // Token endpoint
            if (req.getEndpoint().contains('oauth2/token')) {
                res.setStatusCode(200);
                res.setBody('{"access_token":"test-token-abc"}');
            }
            // Regular API call
            else {
                res.setStatusCode(200);
                res.setBody('{"id":"001","name":"Test Record"}');
            }
            return res;
        }
    }

    @isTest
    static void testPostRecord() {
        Test.setMock(HttpCalloutMock.class, new MockCalloutResponse());

        Invoker inv = new Invoker();
        Map<String, Object> inputData = new Map<String, Object>{
            'SERVICE_NAME' => 'TestService',
            'ENDPOINT' => 'https://example.com/api/records',
            'BODY' => '{"name":"New Record"}'
        };

        Test.startTest();
        Map<String, Object> result = inv.invoke('API_CALLOUT', 'POST_RECORD', 'FwCalloutService', inputData);
        Test.stopTest();

        System.assertNotEquals(null, result);
    }

    @isTest
    static void testGetRecord() {
        Test.setMock(HttpCalloutMock.class, new MockCalloutResponse());

        Invoker inv = new Invoker();
        Map<String, Object> inputData = new Map<String, Object>{
            'SERVICE_NAME' => 'TestService',
            'ENDPOINT' => 'https://example.com/api/records/001'
        };

        Test.startTest();
        Map<String, Object> result = inv.invoke('API_CALLOUT', 'GET_RECORD', 'FwCalloutService', inputData);
        Test.stopTest();

        System.assertNotEquals(null, result);
    }

    @isTest
    static void testGetAuthToken() {
        Test.setMock(HttpCalloutMock.class, new MockCalloutResponse());

        Invoker inv = new Invoker();
        Map<String, Object> inputData = new Map<String, Object>{
            'SERVICE_NAME' => 'TestService'
        };

        Test.startTest();
        Map<String, Object> result = inv.invoke('API_CALLOUT', 'GET_AUTH_TOKEN', 'FwCalloutService', inputData);
        Test.stopTest();

        System.assertNotEquals(null, result);
    }
}
