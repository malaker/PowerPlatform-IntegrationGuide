Listing 2.27 Custom CodeActivity example

```c#
using System;
using System.Activities;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Workflow;

public sealed class ValidateEmailDomain : CodeActivity
{
    [RequiredArgument]
    [Input("Email Address")]
    public InArgument<string> EmailAddress { get; set; }
    
    [Input("Allowed Domains")]
    [Default("contoso.com,fabrikam.com")]
    public InArgument<string> AllowedDomains { get; set; }
    
    [Output("Is Valid")]
    public OutArgument<bool> IsValid { get; set; }
    
    [Output("Domain")]
    public OutArgument<string> Domain { get; set; }

    protected override void Execute(CodeActivityContext executionContext)
    {
        // Get input values
        string email = EmailAddress.Get(executionContext);
        string allowedDomains = AllowedDomains.Get(executionContext);
        
        // Extract domain from email
        string domain = email.Substring(email.LastIndexOf('@') + 1).ToLower();
        
        // Check if domain is allowed
        bool isValid = allowedDomains.ToLower().Contains(domain);
        
        // Set output values
        IsValid.Set(executionContext, isValid);
        Domain.Set(executionContext, domain);
    }
}
```