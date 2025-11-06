
Listing 2.1 PAC CLI - authentication to the environment
```
pac create auth —environment <organizationid>.crm4.dynamics.com
```

Listing 2.2 PAC CLI - creating service principal
```
pac admin create-service-principal --name svc-int-xyz-to-dataverse
```

Listing 2.3 PAC CLI - creating service principal output

```
Connected as ***********************************
Creating Entra ID Application 'svc-int-xyz-to-dataverse'... Done
Creating Entra ID Service Principal... Done

Connected to... Sales Trial
Registering Application '***********************************' with Dataverse... Done
Creating Dataverse system user and assigning role... Done

Application Name         	svc-int-xyz-to-dataverse
Tenant Id			************************************
Application Id               ************************************
Service Principal Id       	************************************
Client Secret                ************************************
Client Secret Expiration 	03/07/2026 13:37:50 +00:00
System User Id             	************************************

```