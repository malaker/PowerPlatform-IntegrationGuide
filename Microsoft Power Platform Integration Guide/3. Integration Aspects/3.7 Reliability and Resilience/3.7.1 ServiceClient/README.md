Listing 3.9 Configuring MaxRetry in ServiceClient instance

```c#
ServiceClient client = new ServiceClient(connectionString)

client.MaxRetryCount = 20;

```

Listing 3.10 C# Helper function that retrieve from FaultException Retry-After property

```c#
using Microsoft.Xrm.Sdk;
using System.ServiceModel;

namespace PowerPlatform.Utils
{
    public class FaultExceptionHelpers
    {
        public static TimeSpan? TryGetRetryAfter(Exception? ex)
        {
            if (ex is FaultException)
            {
                var retryAfter = (ex as FaultException<OrganizationServiceFault>).Detail.ErrorDetails["Retry-After"];
                if (retryAfter is TimeSpan ts)
                {
                    return ts;
                }
                if (retryAfter is string && TimeSpan.TryParse(retryAfter.ToString(), out var parsed))
                {
                    return parsed;
                }
            }

            //Default
            return TimeSpan.FromSeconds(16);
        }
    }
}

```

Listing 3.11 Implementing exponential backoff mechanism to retry logic using Polly library

```c#
using Microsoft.Extensions.DependencyInjection;

using Polly;
using Polly.DependencyInjection;
using Polly.Retry;

//IoC container initialization
var services = new ServiceCollection();

//Registering resilience pipeline
services.AddResiliencePipeline("dataverse-pipeline", (ResiliencePipelineBuilder builder, AddResiliencePipelineContext<string> configure) =>
{
    var loggerInstance = configure.ServiceProvider.GetRequiredService<ILogger<ResiliencePipeline>>();

    builder.AddRetry(new RetryStrategyOptions()
    {
        MaxRetryAttempts = 12,
        //Delay generator based on Retry-After
 DelayGenerator = (ctx) => ValueTask.FromResult(
           FaultExceptionHelpers.TryGetRetryAfter(ctx.Outcome.Exception)),
       //Delay strategy 
       BackoffType = DelayBackoffType.Exponential,
       //The rule that determines when the renewal strategy should be applied 
       ShouldHandle = new PredicateBuilder()
          .Handle<Exception>(ex => ex is FaultException<OrganizationServiceFault> 
    && (ex as FaultException<OrganizationServiceFault>)
        .Detail.ErrorDetails.ContainsKey("Retry-After"),
       //Place for additional retry logic 
       OnRetry = args =>
        {
            loggerInstance.LogWarning("Retry {RetryAttempt} after {Delay}s due to {Error}", args.AttemptNumber, args.RetryDelay, args.Outcome.Exception?.Message ?? "Unkown Error");

            return ValueTask.CompletedTask;
        }
    }
    );
});
```

