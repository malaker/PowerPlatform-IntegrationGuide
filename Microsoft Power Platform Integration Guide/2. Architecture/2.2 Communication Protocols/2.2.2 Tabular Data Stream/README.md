Listing 2.9 C# Example of connecting to TDS Endpoint in .NET Core application

```c#
using Microsoft.Data.SqlClient;
using Microsoft.Identity.Client;

string sqlConn = @"Server=<orgid>.crm4.dynamics.com,5558;Database=<orgid>;Encrypt=True;";

static async Task<string> GetAccessTokenAsync()
{
    var tenantId = "<tenantid>";
    var clientId = "<clientid";
    var clientSecret = "<password>";
    var authority = $"https://login.microsoftonline.com/{tenantId}";

    var app = ConfidentialClientApplicationBuilder.Create(clientId)
        .WithClientSecret(clientSecret)
        .WithAuthority(new Uri(authority))
        .Build();

    string[] scopes = new string[] { "https://<organization>.crm4.dynamics.com/.default" };

    var result = await app.AcquireTokenForClient(scopes).ExecuteAsync();

    return result.AccessToken;
}

using (SqlConnection conn = new SqlConnection())
{
    conn.AccessToken = await GetAccessTokenAsync();

    await conn.OpenAsync();

    var command = conn.CreateCommand();

    command.CommandText = "SELECT TOP 10 name, createdon FROM account";

    var reader = await command.ExecuteReaderAsync();

    while (reader.Read())
    {
        Console.WriteLine($"Account Name: {reader["name"]}, Created On: {reader["createdon"]}");
    }
}

```

