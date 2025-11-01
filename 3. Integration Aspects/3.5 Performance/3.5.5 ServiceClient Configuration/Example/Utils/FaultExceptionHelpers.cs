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
            else if (ex is HttpRequestException httpEx)
            {
                if (httpEx.Data["Retry-After"] is TimeSpan ts)
                {
                    return ts;
                }

                if (httpEx.Data["Retry-After"] is string str && TimeSpan.TryParse(str, out var parsed))
                {
                    return parsed;
                }
            }

            // Custom extraction logic if exception comes from inner response
            if (ex?.Data?["Retry-After"] is string headerVal)
            {
                if (int.TryParse(headerVal, out int seconds))
                    return TimeSpan.FromSeconds(seconds);
            }

            return null;
        }
    }
}
