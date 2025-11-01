Listing 3.22 C# Plugin – both tracing and app insights logging example

```c#
public class PluginDemo : PluginBase
 {
     public PluginDemo() : base(typeof(PluginDemo))
     {
     }

     protected override void ExecuteDataversePlugin(ILocalPluginContext localPluginContext)
     {
         //Application Insights
         localPluginContext.Logger.LogTrace("Hello World");

         //Plug-in Trace Logs 
         localPluginContext.TracingService.Trace("Hello World");
     }
 }

```

Listing 3.23 PAC CLI - updating telemetry instrumentation key

```
pac env update-settings --name telemetryinstrumentationkey --value 12345678-abcd-1234-ef00-9876543210ab
```

Listing 3.24 PAC CLI - enabling Application Insights plugin logging

```
pac env update-settings --name orginsightsenabled --value true
```