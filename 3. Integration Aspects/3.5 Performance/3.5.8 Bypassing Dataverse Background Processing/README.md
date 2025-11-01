Listing 3.6 Bypassing synchronous logic including entity scoped business rules

```c#
//ServiceClient initialization
ServiceClient serviceClient = new ServiceClient(connectionString);

var accountEntity = new Microsoft.Xrm.Sdk.Entity("account");

//here some code that populates entity attributes...

//Preparing request to create account record 
var request = new CreateRequest() { Target = accountEntity };

//Bypass any sync custom plugin or any entity scoped business rule that is configured with an account entity
request.Parameters.Add("BypassBusinessLogicExecution", "CustomSync");

await serviceClient.ExecuteAsync(request);

```

Listing 3.7 Bypassing both synchronous and asynchronous logic

```C#
request.Parameters.Add("BypassBusinessLogicExecution", "CustomSync, CustomAsync");
```

Listing 3.8 Bypassing Power Automate Flows

```c#
request.Parameters.Add("SuppressCallbackRegistrationExpanderJob",true)
```

