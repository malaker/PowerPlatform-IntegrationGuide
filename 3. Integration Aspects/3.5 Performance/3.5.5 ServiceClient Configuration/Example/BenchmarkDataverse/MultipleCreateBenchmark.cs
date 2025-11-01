using BenchmarkDotNet.Attributes;
using BenchmarkDotNet.Engines;
using Microsoft.Extensions.Configuration;
using Microsoft.PowerPlatform.Dataverse.Client;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Messages;
using PowerPlatform.Utils;

[SimpleJob(runStrategy: RunStrategy.ColdStart, iterationCount: 10)]
public class MultipleCreateBenchmark
{
    private ServiceClient serviceClient;

    private List<ServiceClient> clientPool;

    private List<ServiceClient> clientPool2;

    private List<CreateMultipleRequest> entities100;

    private List<CreateMultipleRequest> entities1000;

    private List<CreateMultipleRequest> entities10000;

    private List<CreateMultipleRequest> entities100000;

    private List<CreateMultipleRequest> entities100_2;
    private List<CreateMultipleRequest> entities100_3;
    private List<CreateMultipleRequest> entities1000_2;

    private List<CreateMultipleRequest> entities10000_2;

    private List<CreateMultipleRequest> entities100000_2;

    [GlobalSetup]
    public void GlobalSetup()
    {
        HighPerformanceSetup.Init();

        //Update connection string in configuration file.
        var config = new ConfigurationBuilder().AddJsonFile("appsettings.json").Build();

        var connectionString = config["ConnectionString"];

        ServiceClient client = new ServiceClient(connectionString);

        Console.WriteLine("RecommendedDegreesOfParallelism:" + client.RecommendedDegreesOfParallelism);

        this.serviceClient = client;

        var connectionPoolGenerator = new ConnectionPoolGenerator(connectionString);
        clientPool = connectionPoolGenerator
            .Generate(maxRetryCount: 2, enableAffinitySessionCookie: false, DisableCrossThreadSafeties: true).ToList();

        clientPool2 = connectionPoolGenerator
            .Generate(maxRetryCount: 2, enableAffinitySessionCookie: true, DisableCrossThreadSafeties: true).ToList();

        entities100 = DataGenerator.GenerateCreateMultipleRequest(100, 10);

        entities100_2 = DataGenerator.GenerateCreateMultipleRequest(100, 10);

        entities100_3 = DataGenerator.GenerateCreateMultipleRequest(100, 10);
    }

    [Benchmark]
    public async Task ExecuteCreateMultipleRequest100_CookieDisabledSequential()
    {
        await ExecuteChunks3(entities100_3, clientPool);
    }

    [Benchmark]
    public async Task ExecuteCreateMultipleRequest100_CookieEnabledSequential()
    {
        await ExecuteChunks3(entities100_3, clientPool2);
    }

    [Benchmark]
    public async Task ExecuteCreateMultipleRequest100_CookieDisabledAsync()
    {
        await ExecuteChunks(entities100, clientPool);
    }

    [Benchmark]
    public async Task ExecuteCreateMultipleRequest100_CookieEnabledAsync()
    {
        await ExecuteChunks(entities100, clientPool2);
    }

    [Benchmark]
    public void ExecuteCreateMultipleRequest100_CookieDisabledParallerFor()
    {
        ExecuteChunks2(entities100_2, clientPool);
    }

    [Benchmark]
    public void ExecuteCreateMultipleRequest100_CookieEnabledParallerFor()
    {
        ExecuteChunks2(entities100_2, clientPool2);
    }

    public async Task<IEnumerable<OrganizationResponse>> ExecuteChunks<TRequest>(IList<TRequest> chunks, List<ServiceClient> clientPool) where TRequest : OrganizationRequest
    {
        int poolSize = clientPool.Count;


        List<OrganizationResponse> allResults = new List<OrganizationResponse>(chunks.Count);

        for (var i = 0; i < chunks.Count;)
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

    public IEnumerable<OrganizationResponse> ExecuteChunks2<TRequest>(IList<TRequest> chunks, List<ServiceClient> clientPool) where TRequest : OrganizationRequest
    {
        int poolSize = clientPool.Count;

        OrganizationResponse[] allResults = new OrganizationResponse[chunks.Count];

        ParallelOptions options = new ParallelOptions() { MaxDegreeOfParallelism = poolSize };

        Parallel.For(0, chunks.Count, options, i =>
        {
            allResults[i] = clientPool[i % poolSize].Execute(chunks[i]);
        });

        return allResults;
    }


    public async Task<IEnumerable<OrganizationResponse>> ExecuteChunks3<TRequest>(IList<TRequest> chunks, List<ServiceClient> clientPool) where TRequest : OrganizationRequest
    {
        int poolSize = clientPool.Count;

        List<OrganizationResponse> allResults = new List<OrganizationResponse>(chunks.Count);

        for (var i = 0; i < chunks.Count; i++)
        {
            allResults.Add(await clientPool[i % poolSize].ExecuteAsync(chunks[i]));
        }


        return allResults;
    }
}

