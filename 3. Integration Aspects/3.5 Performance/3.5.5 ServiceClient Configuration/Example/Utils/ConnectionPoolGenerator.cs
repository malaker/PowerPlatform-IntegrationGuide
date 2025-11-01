using Microsoft.PowerPlatform.Dataverse.Client;

namespace PowerPlatform.Utils
{

    public class ConnectionPoolGenerator
    {
        private readonly string _connectionString;
        public ConnectionPoolGenerator(string connectionString)
        {
            _connectionString = connectionString;
        }
        public ServiceClient[] Generate(int maxRetryCount = 10, bool enableAffinitySessionCookie = false, bool DisableCrossThreadSafeties = false, bool useRecommendedSize = true, int customSize = 4)
        {
            ServiceClient serviceClient = new ServiceClient(_connectionString);

            ServiceClient[] pool = new ServiceClient[useRecommendedSize ? serviceClient.RecommendedDegreesOfParallelism : customSize];

            foreach (var i in Enumerable.Range(0, serviceClient.RecommendedDegreesOfParallelism))
            {
                var clonedClient = i == 0 ? serviceClient : serviceClient.Clone();

                clonedClient.EnableAffinityCookie = enableAffinitySessionCookie;

                clonedClient.DisableCrossThreadSafeties = DisableCrossThreadSafeties;

                clonedClient.MaxRetryCount = maxRetryCount;

                pool[i] = clonedClient;
            }

            return pool;

        }
    }
}
