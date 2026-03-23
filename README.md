# SFRoutingFramework

A lightweight routing framework for Salesforce Apex that provides a unified service layer for all request types — UI, REST API, Schedulable, Batch, Triggers, and Platform Events.

## Advantages

- **Single service layer** — Write business logic once and invoke it from any context (LWC, Flow, Trigger, Scheduled Job, Batch, API callout)
- **Zero boilerplate** — The base classes handle routing, async/sync decisions, and dynamic class instantiation. Developers only implement the service layer
- **Loose coupling** — Classes are resolved at runtime via reflection (`Type.forName`), so callers never depend on concrete implementations
- **Built-in async management** — The framework automatically decides whether to run synchronously or enqueue a Queueable based on the current execution context and governor limits
- **Token caching** — REST API callouts use Platform Cache to avoid redundant OAuth token requests, with automatic refresh on expiry or 401 responses
- **Easy to extend** — Add a new process type by creating a service class, adding enum values, and overriding one handler method

## Class Structure

### Core Framework

| Class | Purpose |
|-------|---------|
| **BaseAppLiterals** | Defines the `PROCESS_NAME` enum (`USER_INTERFACE`, `API_CALLOUT`, `RECORD_TRIGGER`, `BATCH`, etc.) used to route requests |
| **BaseLayer** | Virtual base class containing the routing engine. `invokeProcess()` switches on `processName` and delegates to virtual handler methods (`handleUserInterfaceOps`, `handleApiCallOutOps`, etc.). Child classes override the handler they need |
| **Invoker** | Entry point for all callers. Accepts `processName`, `actionName`, `classRef`, and `inputData`, dynamically instantiates the target service class, and invokes the routing engine |
| **FwAppLiterals** | Extends `BaseAppLiterals` with application-specific enums — `ACTION_NAME` (e.g. `CREATE_USER`, `POST_RECORD`, `GET_RECORD`) and `CLASS_REF` (e.g. `FwServiceLayer`, `FwCalloutService`) |
| **FwUtility** | Static utility methods for checking async eligibility (`isAsyncAllowed`) and Queueable job capacity (`areQueuableJobsAllowed`) |
| **FwQueuable** | Queueable implementation that dynamically instantiates and invokes a service class for deferred async processing |

### Service Layers

| Class | Purpose |
|-------|---------|
| **FwServiceLayer** | Extends `BaseLayer`. Handles `USER_INTERFACE` operations by overriding `handleUserInterfaceOps()` with switch routing on `actionName` (`CREATE_USER`, `CREATE_OPPTY`) |
| **FwCalloutService** | Extends `BaseLayer`. Handles `API_CALLOUT` operations by overriding `handleApiCallOutOps()` with switch routing on `actionName` (`GET_AUTH_TOKEN`, `POST_RECORD`, `GET_RECORD`). Includes automatic 401 retry with token refresh |

### REST API & Token Caching

| Class | Purpose |
|-------|---------|
| **HttpCalloutHelper** | Static utility for HTTP requests. Provides `sendRequest()` for general-purpose calls and convenience methods `doGet()`/`doPost()` with Bearer token authentication |
| **TokenCacheManager** | Manages OAuth tokens via Platform Cache (`Cache.Org`). `getToken()` returns a cached token or fetches a fresh one. `clearToken()` forces a refresh. Tokens are cached with a 3500-second TTL (just under the standard 1-hour OAuth expiry) |

### Wrappers

| Class | Purpose |
|-------|---------|
| **FwWrapper** | Contains `UserWrapper` inner class for UI-related data |
| **FwCalloutWrapper** | Contains `CalloutRequest` and `CalloutResponse` inner classes for structuring REST API request/response data |

### Supporting Classes

| Class | Purpose |
|-------|---------|
| **FwClient** | Implements `Schedulable` to invoke the framework from scheduled jobs |
| **DummyQueueable** | Minimal Queueable implementation for testing async processing |

## Call Flow

```
Caller (LWC, Flow, Trigger, Scheduled Job, etc.)
  │
  ▼
Invoker.invoke(processName, actionName, classRef, inputData)
  │
  ▼
Type.forName(classRef) → instantiate → cast to BaseLayer
  │
  ▼
BaseLayer.invokeProcess(inputMap)
  │  switch on processName
  ▼
routeXxxRequest(inputMap)
  │  checks async eligibility
  ▼
handleXxxOps(inputMap)  ← overridden by service class
  │  switch on actionName
  ▼
Business logic executes → results returned via outputMap
```

### REST API Callout Example

```apex
Invoker inv = new Invoker();
Map<String, Object> data = new Map<String, Object>{
    'SERVICE_NAME' => 'MyNamedCredential',
    'ENDPOINT'     => 'https://api.example.com/records',
    'BODY'         => '{"name": "Acme Corp"}'
};
Map<String, Object> result = inv.invoke('API_CALLOUT', 'POST_RECORD', 'FwCalloutService', data);
FwCalloutWrapper.CalloutResponse res = (FwCalloutWrapper.CalloutResponse) result.get('RESPONSE');
System.debug('Status: ' + res.statusCode + ' Success: ' + res.isSuccess);
```

## Setup

### Platform Cache (required for token caching)
1. Go to **Setup → Platform Cache**
2. Create a new partition named **ApiTokens**
3. Set type to **Org** and allocate at least **1 MB**

### Token Endpoint Configuration
Customize `TokenCacheManager.requestNewToken()` to match your org's OAuth flow. The default implementation uses Named Credentials with a `client_credentials` grant type.
