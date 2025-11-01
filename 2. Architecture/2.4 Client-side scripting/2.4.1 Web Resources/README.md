Listing 2.10 IIFE for Utilities scripts example

```js
var FormExtensions = FormExtensions || {};

(function (common) {

    function trace(message) {
        console.trace(message);
    }

    function onLoad() {

       if (!common.Utilities) {
           
           common.Utilities = {
               trace: trace,
               onLoad: onLoad
           };
       }
    }

    if (!common.Utilities){
        
       onLoad();
    
    }

    return common.Utilities;

})(FormExtensions.Common = FormExtensions.Common || {});

```

Listing 2.11 IIFE function to be registered on Contact form  on onLoad event

```js
// Simple Contact Form Script with IIFE Pattern
var FormExtensions = FormExtensions || {};

FormExtensions.ContactForm = (function () {
    "use strict";

    // Private helper function
    function isValidEmail(email) {
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    function onEmailChange(executionContext){
            
     var formContext = executionContext.getFormContext();
            
     var emailAttribute = formContext.getAttribute("emailaddress1");

            if (!emailAttribute) return;

            var emailValue = emailAttribute.getValue();
            
     var emailControl = formContext.getControl("emailaddress1");

            // Clear any previous validation messages
            emailControl.clearNotification("email_validation");

            // Validate email if it has a value
            if (emailValue && !isValidEmail(emailValue)) {
                emailControl.setNotification("Please enter a valid email address", "email_validation");
            }
    }

    function onLoad(executionContext) {
        
FormExtensions.Common.Utilities.trace("ContactForm-onLoad started");

       var formContext = executionContext.getFormContext();

       formContext.getAttribute("emailaddress1").addOnChange(onEmailChange) 
        // You can add initialization logic here
        // For example: set field requirements, default values, etc.
       FormExtensions.Common.Utilities.trace("ContactForm-onLoad finished");
    }

    // Public methods
    return {
        onLoad: onLoad
    };
})();

```

Listing 2.12 TypeScript based Web Resource project – PowerShell initialization script

```
# Step 1: Create project directory
mkdir d365-webresources
cd d365-webresources

# Step 2: Npm initialization with defaults
npm init -y

# Step 3: Install TypeScript and build dependencies
npm install --save-dev typescript
npm install --save-dev ts-loader
npm install --save-exact --save-dev esbuild
# Step 4: Install D365 type definitions
npm install --save-dev @types/xrm

# Step 5: Install additional development dependencies
npm install --save-dev rimraf
npm install --save-dev @types/node
npm install --save-dev prettier

# Step 6: Create TypeScript configuration file and define build script in package.json
npx tsc --init
npm pkg set scripts.build="node build.mjs"

# Step 7: Create project folder structure
New-Item -Path src -ItemType "Directory"
New-Item -Path src/types -ItemType "Directory"
New-Item -Path src/forms -ItemType "Directory"
New-Item -Path src/shared -ItemType "Directory"
New-Item -Path src/ribbon -ItemType "Directory"
New-Item -Path dist -ItemType "Directory"

# Step 8: Create example source files
New-Item -Path src/forms/contactForm.ts -ItemType "File"
New-Item -Path src/shared/utilities.ts -ItemType "File"

# Step 9: Create .gitignore file
New-Item -Path .gitignore -ItemType "File"
```

Listing 2.13 ESBuild build script for web resources
```js
import * as esbuild from 'esbuild'

const entryPoints = [{path:'src/forms/contactForm.ts',out:'dist/contactForm.js'}]

entryPoints.forEach(async entry=>{
  await esbuild.build({
  entryPoints: [entry.path],
  bundle: true,
  outfile: entry.out,
  });
});

```

Listing 2.14 Typescript configuration

```json
{
  // Visit https://aka.ms/tsconfig to read more about this file
  "compilerOptions": {
    // File Layout
    "rootDir": "./src",
    "outDir": "./dist",
    // Environment Settings
    // See also https://aka.ms/tsconfig/module
    "module": "nodenext",
    "target": "esnext",
    "types": ["xrm"],
    // Other Outputs
    "sourceMap": true,
    "declaration": true,
    "declarationMap": true,
    // Stricter Typechecking Options
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    // Recommended Options
    "strict": true,
    "verbatimModuleSyntax": false,
    "isolatedModules": true,
    "noUncheckedSideEffectImports": true,
    "moduleDetection": "force",
    "skipLibCheck": true,
  }
}

```

Listing 2.15  Utilities script - TypeScript equivalent of Listing 2.10

```ts
export const trace = (message:string)=>console.log(message);
```

Listing 2.16 ContactForm - TypeScript equivalent of Listing 2.11

```ts
// we can import other functions and reuse them
import { trace } from "../shared/utilities";

export namespace FormExtensions.ContactForm {
    
    // Private helper function
    const isValidEmail = (email:string) => {
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    const onEmailChange = (executionContext:Xrm.Events.EventContext)=>{
        var formContext = executionContext.getFormContext();
            
            var emailAttribute = formContext.getAttribute<Xrm.Attributes.StringAttribute>("emailaddress1");

            if (!emailAttribute) return;

            var emailValue = emailAttribute.getValue();

            var emailControl = formContext.getControl<Xrm.Controls.StringControl>("emailaddress1")!;

            // Clear any previous validation messages
            emailControl.clearNotification("email_validation");

            // Validate email if it has a value
            if (emailValue && !isValidEmail(emailValue)) {
                emailControl.setNotification("Please enter a valid email address", "email_validation");
            }
    }

    //public function
    export const onLoad = (executionContext:Xrm.Events.EventContext)=>{
        
        trace("AccountForm-onLoad started");

        let formContext = executionContext.getFormContext();

        var emailAttribute = formContext.getAttribute<Xrm.Attributes.StringAttribute>("emailaddress1");

        emailAttribute?.addOnChange(onEmailChange);

        trace("AccountForm-onLoad finished");
    }
}

```

Listing 2.17 NPM - building Web Resource project

```
npm run build
```