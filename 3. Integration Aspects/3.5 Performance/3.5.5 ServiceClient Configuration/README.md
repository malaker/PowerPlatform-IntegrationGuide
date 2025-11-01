Listing 3.1 C# Example of configuring .NET process to boost ServiceClient performance

```c#
// Increase the minimum number of threads reserved for this application to make connections compile faster. The default values are minWorkerThreads = 4 and minIOCP = 4.
ThreadPool.SetMinThreads(50, 50);

// Change the default maximum number of .NET connections to a remote service: from 2 to 32,000.
System.Net.ServicePointManager.DefaultConnectionLimit = 32000;

// Disable the "Expect 100 Continue" message - a value of true causes the caller to wait until the connection to the server is confirmed by a round of requests and responses.
System.Net.ServicePointManager.Expect100Continue = false;

// It can reduce the overall transmission overhead, but may cause delays in the delivery of data packets.
System.Net.ServicePointManager.UseNagleAlgorithm = false;

```

Listing 3.2 C# Example of benchmark tests

```c#
[Benchmark]
public async Task CookieDisabledSequential()
{
    await ExecuteChunksSequential(entities100, clientPool);
}

[Benchmark]
public async Task CookieEnabledSequential()
{
    await ExecuteChunksSequential(entities100, clientPool2);
}

[Benchmark]
public async Task CookieDisabledAsync()
{
    await ExecuteChunksAsync(entities100, clientPool);
}

[Benchmark]
public async Task CookieEnabledAsync()
{
    await ExecuteChunksAsync(entities100, clientPool2);
}

[Benchmark]
public async Task CookieDisabledParallerFor()
{
    await ExecuteChunksParalell(entities100, clientPool);
}

[Benchmark]
public async Task CookieEnabledParallerFor()
{
    await ExecuteChunksParalell(entities100, clientPool2);
}

```

Listing 3.3 C# Sequential records insertion

```c#
public async Task<IEnumerable<OrganizationResponse>> ExecuteChunksSequential<TRequest>(IList<TRequest> chunks, List<ServiceClient> clientPool) where TRequest : OrganizationRequest
{
    int poolSize = clientPool.Count;

    var allResults = new List<OrganizationResponse>(chunks.Count);

    for (var i = 0; i < chunks.Count;i++)
    {
        allResults.Add(await clientPool[i % poolSize].ExecuteAsync(chunks[i]));     
    }
    return allResults;
}

```

Listing 3.4 C# Asynchronous records insertion implementation

```c#
public async Task<IEnumerable<OrganizationResponse>> ExecuteChunksAsync<TRequest>(IList<TRequest> chunks,List<ServiceClient> clientPool) where TRequest : OrganizationRequest
 {
     int poolSize = clientPool.Count;
     var allResults = new List<OrganizationResponse>(chunks.Count);
     for(var i = 0; i < chunks.Count; )
     {
         var taskResults = chunks
             .Skip(i)
             .Take(poolSize)
             .Select((req, idx) => clientPool[idx % poolSize].ExecuteAsync(req)).ToArray();

         var results = await Task.WhenAll(taskResults);
         
         allResults.AddRange(results);

         i = i + poolSize;
     }
     return allResults;
}

```

Listing 3.5 C# Parallel.For benchmark

```c#
public async Task<IEnumerable<OrganizationResponse>> ExecuteChunksParalell<TRequest>(IList<TRequest> chunks, List<ServiceClient> clientPool) where TRequest : OrganizationRequest
{
    int poolSize = clientPool.Count;

    OrganizationResponse[] allResults = new OrganizationResponse[chunks.Count];

    ParallelOptions options = new ParallelOptions(){ 
                            MaxDegreeOfParallelism = poolSize 
                        };

    Parallel.For(0, chunks.Count, options, i =>
    {
        allResults[i] = clientPool[i % poolSize].Execute(chunks[i]);
    });
    
    return allResults;
}

```