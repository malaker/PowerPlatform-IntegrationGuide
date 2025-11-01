Listing 4.1 PAC CLI - plugin project initialization

```
pac plugin init
```

Listing 4.2 Dotnet CLI - adding Kiota Bundle dependency

```
dotnet add package Microsoft.Kiota.Bundle
```

Listing 4.3 Dotnet CLI - adding OpenApi Kiota dependency

```
dotnet tool install --global Microsoft.OpenApi.Kiota
```

Listing 4.4 Kiota generating client

```
kiota generate -l CSharp -c BffClient -n D365.Bff.Clients 
-d ./D365-Bff.swagger.yml -o ./Bff
```

Listing 4.5 C# Example of using Kiota generated client from OpenAPI definition

```c#
// Entry point for custom business logic execution
protected override void ExecuteDataversePlugin(ILocalPluginContext localPluginContext)
{
    if (localPluginContext == null)
    {
        throw new ArgumentNullException(nameof(localPluginContext));
    }

    //e.g Environment Variable Retrieval which stores Subscription Key 
    var settings = GetIntegrationSettings(localPluginContext);

    using (var httpClient = GetHttpClient(settings.BaseAddress))
    {
        //Subscription based authentication
        var apiKeyAuthenticationProvider = new ApiKeyAuthenticationProvider(settings.SubscriptionKey, settings.SubscriptionParamName, KeyLocation.Header, settings.AllowedHosts);

        var requestAdapter = new HttpClientRequestAdapter(apiKeyAuthenticationProvider, httpClient: httpClient);

        BffClient bffClient = new BffClient(requestAdapter);

        var response = bffClient.Api.Documents.GetAsync().GetAwaiter().GetResult();

        //further part that uses returned data from APIM
    }
}
```

Listing 4.6 C# Example of customizing Kiota HttpClientRequestAdapter to use custom token provider

```c#
IAccessTokenProvider tokenProvider = new MyTokenProvider(localPluginContext);

var accessTokenProvider = new BaseBearerTokenAuthenticationProvider(tokenProvider);

var requestAdapter = new HttpClientRequestAdapter(apiKeyAuthenticationProvider, httpClient: httpClient);

BffClient bffClient = new BffClient(requestAdapter);

```