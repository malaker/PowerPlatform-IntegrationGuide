Listing 2.32 Plugin Managed Identities - csproj target configuration for nuget package signing


```xml
<PropertyGroup>
  <NoWarn>$(NoWarn);NU3018;NU3002;NU3034</NoWarn>
</PropertyGroup>
  
<Target Name="SignNuget" AfterTargets="Pack">
  <Exec Command="dotnet nuget sign --certificate-path codesign.pfx --certificate-password <PASSWORD> $(TargetDir)../<PROJECT_NAME>.1.0.0.nupkg --verbosity detailed" />
</Target>

```

Listing 2.33 Plugin Managed Identity - Federated Credentials, Issuer

```
https://login.microsoftonline.com/{tenantId}/v2.0
```

Listing 2.34 Plugins Managed Identities - Federated Credentials Value when using Self Signed Certificate

```
/eid1/c/pub/t/{encodedTenantId}/a/qzXoWDkuqUa3l6zM5mM0Rw/n/plugin/e/{environmentId}/h/{hash}
```

Listing 2.35 Plugin Managed Identities - Creating record for managed identity in Dataverse

```
var payload = {
  applicationid: "2300c47e-8778-4168-8b73-be316fdf2f35", //application ID from Portal Azure
  managedidentityid: "2300c47e-8778-4168-8b73-be316fdf2f35", //it can be any GUID
  credentialsource: 2,
  subjectscope: 1,
  tenantid: "6e712ab3-91fb-4585-ad13-3d607e8101e2" //your Azure Tenant ID
  version: 1
};

fetch('https://orgfa1234.crm4.dynamics.com/api/data/v9.0/managedidentities',{method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify(payload)});
```

Listing 2.36 Plugin Managed Identity - linking plugin package with managed identity record in Dataverse

```
fetch("https://orgfa1234.crm4.dynamics.com/api/data/v9.0/pluginpackages(072e46b2-58b6-f011-bbd2-7ced8d8f87ba)",{method:"PATCH",headers:{"Content-Type":"application/json"},body:JSON.stringify({
  "managedidentityid@odata.bind": "/managedidentities(2300c47e-8778-4168-8b73-be316fdf2f35)"
})})

```

Listing 2.37 Plugins Managed Identities - Federated Credentials Value when using trusted certificate

```
/eid1/c/pub/t/{encodedTenantId}/a/qzXoWDkuqUa3l6zM5mM0Rw/n/plugin/e/{environmentId}/i/{issuer}/s/{certificateSubject}
```