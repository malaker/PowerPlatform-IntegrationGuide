Listing 5.1 Client side script to be loaded as part of Custom Channel Provider (Channel Url)

```js
<script type="text/javascript">
    const cifLoader = (function () {

        //in typical project configuration fetched from either channel settings or environment variable
        const scripts = {
            main_cif_library: {
                uri: 'https://orgXYZ.crm4.dynamics.com/webresources/Widget/msdyn_ciLibrary.js',
                attributes: [
                    { 'name': 'data-crmurl', 'value': 'https://orgXYZ.crm4.dynamics.com' },
                    { 'name': 'data-cifid', 'value': 'CIFMainLibrary' }
                ]
            },
            communication_widget: {
                uri: 'https://orgXYZ.crm4.dynamics.com/WebResources/kb_contactcenterbundle'
            }
        };

        //helper function that loads asynchronously CIF and Widget dependencies
        function loadScript(url, attributes, callback) {
            // Create a new script element
            const script = document.createElement('script');

            if (attributes) {

                for (let i = 0; i < attributes.length; i++) {

                    if (attributes[i].name && attributes[i].value) {

                        script.setAttribute(attributes[i].name, attributes[i].value);

                    }
                }
            }

            // Set the source URL
            script.src = url;

            // Optional: Set script type (defaults to 'text/javascript')
            script.type = 'text/javascript';

            // Optional: Set async loading
            script.async = true;

            // Handle successful load
            script.onload = function () {
                console.log(`Script loaded successfully: ${url}`);
                if (callback) callback(null, script);
            };

            // Handle load errors
            script.onerror = function () {
                console.error(`Failed to load script: ${url}`);
                if (callback) callback(new Error(`Script load error: ${url}`));
            };

            // Append the script to the document
            document.head.appendChild(script);

            return script;
        }

        function showWidget() {
            //load widget and dock communication widget
             loadScript(scripts.communication_widget.uri, [], function(){
                 Microsoft.CIFramework.setMode(1);
             });
        }
        //starting default session to show there widget that is docked by default
        //default session is configured to display My Active Cases View
        function startDefaultSession() {

            let input = {
                "templateName": "kb_default_session",
                "custom_title": "Cases",
                "templateParameters": {
                    "entityName": "incident",
                    "viewId": "00000000-0000-0000-00aa-000010001028",
                    "viewType": 0
                }
            }

            Microsoft.CIFramework.createSession(input);
        }

        function initCif() {

            showWidget();

            startDefaultSession();
        }

        function loadCifLibrary() {
            window.addEventListener("CIFInitDone", function () {

                initCif();

                //since now  Microsoft.CIFramework API is available to use in the communication widget
               
            });

            loadScript(scripts.main_cif_library.uri, scripts.main_cif_library.attributes);
        }

        return {
            load: loadCifLibrary
        }
    })();

    cifLoader.load();
</script>
```