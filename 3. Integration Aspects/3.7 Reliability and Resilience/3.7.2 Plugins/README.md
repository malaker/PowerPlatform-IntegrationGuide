Listing 3.12 C# Example of built in retry mechanism in asynchronous plugins

```c#
using (var httpClient = new HttpClient())
{
    httpClient.Timeout = TimeSpan.FromSeconds(30);

    httpClient.DefaultRequestHeaders.ConnectionClose = true;
   
    HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Get, requestUri);

    SetAuthenticationHeaders(request);

    HttpResponseMessage response = httpClient.SendAsync(request).GetAwaiter().GetResult();

    if (!response.IsSuccessStatusCode 
        && response.StatusCode == HttpStatusCode.ServiceUnavailable || response.StatusCode == HttpStatusCode.BadGateway)
    {
        throw new InvalidPluginExecutionException(OperationStatus.Retry, $"External Call Status {Enum.GetName(typeof(HttpStatusCode), response.StatusCode)}. Retry operation will be scheduled soon.");
    }

    //further http response processing
}
```