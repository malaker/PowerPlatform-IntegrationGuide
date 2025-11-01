Listing 2.19 PCF control project initialization

```
pac pcf init --namespace ProjectNamespace --name GridComponent --template dataset --framework react  --run-npm-install
```

Listing 2.20 PCF ControlManifest.xml

```xml
<?xml version="1.0" encoding="utf-8" ?>
<manifest>
  <control namespace="ProjectNamespace" constructor="GridComponent" version="0.0.1" display-name-key="GridComponent" description-key="GridComponent description" control-type="virtual" >
    <!--external-service-usage node declares whether this 3rd party PCF control is using external service or not, if yes, this control will be considered as premium and please also add the external domain it is using.
    If it is not using any external service, please set the enabled="false" and DO NOT add any domain below. The "enabled" will be false by default.
    Example1:
      <external-service-usage enabled="true">
        <domain>www.Microsoft.com</domain>
      </external-service-usage>
    Example2:
      <external-service-usage enabled="false">
      </external-service-usage>
    -->
    <external-service-usage enabled="false">
      <!--UNCOMMENT TO ADD EXTERNAL DOMAINS
      <domain></domain>
      <domain></domain>
      -->
    </external-service-usage>
    <!-- dataset node represents a set of entity records on CDS; allow more than one datasets -->
    <data-set name="sampleDataSet" display-name-key="Dataset_Display_Key">
      <!-- 'property-set' node represents a unique, configurable property that each record in the dataset must provide. -->
      <!-- UNCOMMENT TO ADD PROPERTY-SET NODE
      <property-set name="samplePropertySet" display-name-key="Property_Display_Key" description-key="Property_Desc_Key" of-type="SingleLine.Text" usage="bound" required="true" />
      -->
    </data-set>
    <resources>
      <code path="index.ts" order="1"/>
      <platform-library name="React" version="16.14.0" />
      <platform-library name="Fluent" version="9.46.2" />
      <!-- UNCOMMENT TO ADD MORE RESOURCES
      <css path="css/GridComponent.css" order="1" />
      <resx path="strings/GridComponent.1033.resx" version="1.0.0" />
      -->
    </resources>
    <!-- UNCOMMENT TO ENABLE THE SPECIFIED API
    <feature-usage>
      <uses-feature name="Device.captureAudio" required="true" />
      <uses-feature name="Device.captureImage" required="true" />
      <uses-feature name="Device.captureVideo" required="true" />
      <uses-feature name="Device.getBarcodeValue" required="true" />
      <uses-feature name="Device.getCurrentPosition" required="true" />
      <uses-feature name="Device.pickFile" required="true" />
      <uses-feature name="Utility" required="true" />
      <uses-feature name="WebAPI" required="true" />
    </feature-usage>
    -->
  </control>
</manifest>
```

Listing 2.21 PCF Control index.ts

```ts
import { IInputs, IOutputs } from "./generated/ManifestTypes";
import { HelloWorld, IHelloWorldProps } from "./HelloWorld";
import * as React from "react";
import DataSetInterfaces = ComponentFramework.PropertyHelper.DataSetApi;
type DataSet = ComponentFramework.PropertyTypes.DataSet;

export class GridComponent implements ComponentFramework.ReactControl<IInputs, IOutputs> {
    private theComponent: ComponentFramework.ReactControl<IInputs, IOutputs>;
    private notifyOutputChanged: () => void;

    /**
     * Empty constructor.
     */
    constructor() { }

    /**
     * Used to initialize the control instance. Controls can kick off remote server calls and other initialization actions here.
     * Data-set values are not initialized here, use updateView.
     * @param context The entire property bag available to control via Context Object; It contains values as set up by the customizer mapped to property names defined in the manifest, as well as utility functions.
     * @param notifyOutputChanged A callback method to alert the framework that the control has new outputs ready to be retrieved asynchronously.
     * @param state A piece of data that persists in one session for a single user. Can be set at any point in a controls life cycle by calling 'setControlState' in the Mode interface.
     */
    public init(
        context: ComponentFramework.Context<IInputs>,
        notifyOutputChanged: () => void,
        state: ComponentFramework.Dictionary
    ): void {
        this.notifyOutputChanged = notifyOutputChanged;
    }
    /**
     * Called when any value in the property bag has changed. This includes field values, data-sets, global values such as container height and width, offline status, control metadata values such as label, visible, etc.
     * @param context The entire property bag available to control via Context Object; It contains values as set up by the customizer mapped to names defined in the manifest, as well as utility functions
     * @returns ReactElement root react element for the control
     */
    public updateView(context: ComponentFramework.Context<IInputs>): React.ReactElement {
        const props: IHelloWorldProps = { name: 'Power Apps' };
        return React.createElement(
            HelloWorld, props
        );
    }

    /**
     * It is called by the framework prior to a control receiving new data.
     * @returns an object based on nomenclature defined in manifest, expecting object[s] for property marked as "bound" or "output"
     */
    public getOutputs(): IOutputs {
        return {};
    }
    /**
     * Called when the control is to be removed from the DOM tree. Controls should use this call for cleanup.
     * i.e., cancelling any pending remote calls, removing listeners, etc.
     */
    public destroy(): void {
        // Add code to cleanup control if necessary
    }
}
```

Listing 2.22 Building PCF Control

```
npm run build
```

Listing 2.23 Output of PCF build process

```
[10:59:27 AM] [build] Initializing...
[10:59:27 AM] [build] Validating manifest...
[10:59:27 AM] [build] Validating control...
[10:59:31 AM] [build] Generating manifest types...
[10:59:31 AM] [build] Generating design types...
[10:59:31 AM] [build] Running ESLint...
[10:59:37 AM] [build] Compiling and bundling control...
[Webpack stats]:
asset bundle.js 8.64 KiB [emitted] (name: main)
runtime modules 937 bytes 4 modules
built modules 2.43 KiB [built]
  cacheable modules 2.35 KiB
    ./GridComponent/index.ts 2.12 KiB [built] [code generated]
    ./GridComponent/HelloWorld.tsx 242 bytes [built] [code generated]
  external "Reactv16" 42 bytes [built] [code generated]
  external "FluentUIReactv940" 42 bytes [built] [code generated]
webpack 5.101.3 compiled successfully in 7183 ms
[10:59:46 AM] [build] Generating build outputs...
[10:59:46 AM] [build] Succeeded
```

Listing 2.24 Initialization Dataverse solution for PCF control

```
mkdir solution

cd solution

pac solution init --publisher-name <PUBLISHER_NAME>  --publisher-prefix <PREFIX>

pac solution add-reference --path ../

```

Listing 2.25 Configuring solution type to be build

```xml
<PropertyGroup>
    <SolutionPackageType>Managed</SolutionPackageType>
    <SolutionPackageEnableLocalization>false<SolutionPackageEnableLocalization>
</PropertyGroup>
```

Listing 2.26 Building solution

```
dotnet build
```