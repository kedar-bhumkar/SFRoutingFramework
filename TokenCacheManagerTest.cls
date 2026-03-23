@isTest
public with sharing class TokenCacheManagerTest {

    private class MockTokenResponse implements HttpCalloutMock {
        private Integer statusCode;
        private String body;

        public MockTokenResponse(Integer statusCode, String body) {
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
    static void testGetTokenCacheMiss() {
        Test.setMock(HttpCalloutMock.class, new MockTokenResponse(200, '{"access_token":"fresh-token-123"}'));

        Test.startTest();
        String token = TokenCacheManager.getToken('TestService');
        Test.stopTest();

        System.assertEquals('fresh-token-123', token);
    }

    @isTest
    static void testGetTokenFailedRequest() {
        Test.setMock(HttpCalloutMock.class, new MockTokenResponse(401, '{"error":"invalid_client"}'));

        Test.startTest();
        String token = TokenCacheManager.getToken('BadService');
        Test.stopTest();

        System.assertEquals(null, token);
    }

    @isTest
    static void testClearToken() {
        // Just verify clearToken does not throw
        Test.startTest();
        TokenCacheManager.clearToken('TestService');
        Test.stopTest();
    }
}
