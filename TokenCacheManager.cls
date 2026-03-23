public with sharing class TokenCacheManager {

    private static final String CACHE_PARTITION = 'local.ApiTokens';
    private static final Integer DEFAULT_TTL = 3500; // seconds, just under 1hr

    public static String getToken(String serviceName) {
        String cachedToken = (String) Cache.Org.get(CACHE_PARTITION + '.' + serviceName);

        if (String.isNotBlank(cachedToken)) {
            System.debug('Token cache hit for ' + serviceName);
            return cachedToken;
        }

        System.debug('Token cache miss for ' + serviceName + ', requesting new token...');
        String freshToken = requestNewToken(serviceName);
        if (String.isNotBlank(freshToken)) {
            Cache.Org.put(CACHE_PARTITION + '.' + serviceName, freshToken, DEFAULT_TTL);
        }
        return freshToken;
    }

    public static void clearToken(String serviceName) {
        Cache.Org.remove(CACHE_PARTITION + '.' + serviceName);
    }

    private static String requestNewToken(String serviceName) {
        // Read token endpoint and credentials from Custom Metadata or Named Credential
        // Example: OAuth2 client_credentials flow
        // Customize this method per your org's authentication requirements

        String tokenEndpoint = 'callout:' + serviceName + '/services/oauth2/token';
        Map<String, String> headers = new Map<String, String>{
            'Content-Type' => 'application/x-www-form-urlencoded'
        };
        String body = 'grant_type=client_credentials';

        HttpResponse res = HttpCalloutHelper.sendRequest(tokenEndpoint, 'POST', headers, body);

        if (res.getStatusCode() == 200) {
            Map<String, Object> parsed = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            return (String) parsed.get('access_token');
        }

        System.debug('Token request failed: ' + res.getStatusCode() + ' ' + res.getBody());
        return null;
    }
}
