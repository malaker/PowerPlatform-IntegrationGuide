Listing 3.21 C# ITracingService example

```c#
public class PluginDemo : PluginBase
{
    protected override void ExecuteDataversePlugin(ILocalPluginContext localPluginContext)
    {
        localPluginContext.TracingService.Trace("Hello World");
    }
}

```