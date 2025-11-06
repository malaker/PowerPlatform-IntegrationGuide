
Listing 2.4 PowerShell script - invoking Web API
```pwsh
#Powershell script (fragment)
#organization URL
$dataverse_base_uri="https://orgxyz.crm4.dynamics.com"
# Azure Tenant Id (Directory Id)
$tenantid="<TENANT ID>" 
# Application Id
$clientid="<APPLICATION_ID>" 
# Client secret
$client_secret="<CLIENT_SECRET>" 

$body = "client_id=$clientid&client_secret=$client_secret&grant_type=client_credentials&scope=$dataverse_base_uri/.default"

#Obtaining Access Token 
$access_token = (Invoke-RestMethod -Method POST -Uri "https://login.microsoftonline.com/$tenantid/oauth2/v2.0/token" -ContentType "application/x-www-form-urlencoded" -Body $body).access_token

$req_headers = @{ 
"Accept"="application/json"
"OData-MaxVersion"="4.0"
"OData-Version"="4.0"
"Authorization"="Bearer $access_token"
}

#Invoke Dataverse Web API
Invoke-RestMethod -Method GET -Uri "$dataverse_base_uri/api/data/v9.2/accounts?`$select=name,createdon&`$filter=createdon%20gt%20%2706/02/2025%27" -Headers $req_headers | ConvertTo-Json

```

Listing 2.5 HTTP request - filtering records using ODATA in Dataverse

```
GET /api/data/v9.2/accounts?$select=name,createdon&$filter=createdon gt '06/02/2025' HTTP/1.1
Host: [Organization URL]
Accept: application/json
OData-MaxVersion: 4.0
OData-Version: 4.0
Authorization: "Bearer ey..."
```

Listing 2.6 HTTP response - filtering records using ODATA in Dataverse

```
HTTP/1.1 200 OK
Content-Type:application/json; odata.metadata=minimal
OData-Version: 4.0

{
  "@odata.context": "https://[Organization URL]/api/data/v9.2/$metadata#accounts(name,createdon)",
  "value": [
    {
      "@odata.etag": "W/\"5432895\"",
      "accountid": "88cea450-cb0c-ea11-a813-000d3a1b1223",
      "name": "Fabrikam, Inc.",
      "createdon": "2025-06-15T01:33:41Z"
    }]
}
```

Listing 2.7 C# based Web API call using SDK

```c#
//Example C# Code
using Microsoft.PowerPlatform.Dataverse.Client;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Query;

var connectionString = @"AuthType=ClientSecret;
                 		url=https://orgurl.crm.dynamics.com;
                        	ClientId=your_client_id;
                        	ClientSecret=your_client_secret;"
//Dataverse client initialization
ServiceClient client = new ServiceClient(connectionString);
//Query initialization
QueryExpression query = new QueryExpression("account");

//Column selection
query.Columns = new ColumnSet("name","createdon");

//Filter definition
var condition = new ConditionExpression("createdon", ConditionOperator.GreaterThan, new DateTime(2025, 6, 2));

query.Criteria.AddCondition(condition);

// Query execution
EntityCollection results = service.RetrieveMultiple(query);
// Further logic…
```


Listing 2.8 C# - RetrieveMultiple, Paging Example

```c#
EntityCollection results = null;

do {

//Query execution
results = service.RetrieveMultiple(query);

//Paging cookie update, it stores required data for pagination.
query.PageInfo.PagingCookie = results.PagingCookie;

query.PageInfo.PageNumber++;

} while (results.MoreRecords);

```