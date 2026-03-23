public with sharing class FwCalloutService extends BaseLayer {
    public FwCalloutService() {}


    private Map <String,Object> handleApiCallOutOps(Map<String, Object>  inputMap){
        System.debug('Inside FwCalloutService handleApiCallOutOps...');

        Map<String, Object> outputMap = new Map<String, Object>();

        switch on actionName {
                when 'GET_AUTH_TOKEN' {
                    getAuthToken(inputMap, outputMap);
                }

                when 'POST_RECORD' {
                    postRecord(inputMap, outputMap);
                }

                when 'GET_RECORD' {
                    getRecord(inputMap, outputMap);
                }

        }

        return outputMap;
    }


    private void getAuthToken(Map<String, Object> inputMap, Map<String, Object> outputMap){
        System.debug('Inside getAuthToken...');
        String serviceName = (String) inputMap.get('SERVICE_NAME');
        String token = TokenCacheManager.getToken(serviceName);
        outputMap.put('TOKEN', token);
    }

    private void postRecord(Map<String, Object> inputMap, Map<String, Object> outputMap){
        System.debug('Inside postRecord...');
        String serviceName = (String) inputMap.get('SERVICE_NAME');
        String endpoint = (String) inputMap.get('ENDPOINT');
        String body = (String) inputMap.get('BODY');

        String token = TokenCacheManager.getToken(serviceName);
        HttpResponse res = HttpCalloutHelper.doPost(endpoint, token, body);

        FwCalloutWrapper.CalloutResponse response = new FwCalloutWrapper.CalloutResponse();
        response.statusCode = res.getStatusCode();
        response.responseBody = res.getBody();
        response.isSuccess = (res.getStatusCode() >= 200 && res.getStatusCode() < 300);

        // Retry once on 401 with fresh token
        if (res.getStatusCode() == 401) {
            System.debug('Got 401, clearing token cache and retrying...');
            TokenCacheManager.clearToken(serviceName);
            token = TokenCacheManager.getToken(serviceName);
            res = HttpCalloutHelper.doPost(endpoint, token, body);
            response.statusCode = res.getStatusCode();
            response.responseBody = res.getBody();
            response.isSuccess = (res.getStatusCode() >= 200 && res.getStatusCode() < 300);
        }

        outputMap.put('RESPONSE', response);
    }

    private void getRecord(Map<String, Object> inputMap, Map<String, Object> outputMap){
        System.debug('Inside getRecord...');
        String serviceName = (String) inputMap.get('SERVICE_NAME');
        String endpoint = (String) inputMap.get('ENDPOINT');

        String token = TokenCacheManager.getToken(serviceName);
        HttpResponse res = HttpCalloutHelper.doGet(endpoint, token);

        FwCalloutWrapper.CalloutResponse response = new FwCalloutWrapper.CalloutResponse();
        response.statusCode = res.getStatusCode();
        response.responseBody = res.getBody();
        response.isSuccess = (res.getStatusCode() >= 200 && res.getStatusCode() < 300);

        // Retry once on 401 with fresh token
        if (res.getStatusCode() == 401) {
            System.debug('Got 401, clearing token cache and retrying...');
            TokenCacheManager.clearToken(serviceName);
            token = TokenCacheManager.getToken(serviceName);
            res = HttpCalloutHelper.doGet(endpoint, token);
            response.statusCode = res.getStatusCode();
            response.responseBody = res.getBody();
            response.isSuccess = (res.getStatusCode() >= 200 && res.getStatusCode() < 300);
        }

        outputMap.put('RESPONSE', response);
    }


}
