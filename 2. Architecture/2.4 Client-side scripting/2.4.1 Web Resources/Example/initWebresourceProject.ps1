<#
.SYNOPSIS
    Initializes a TypeScript-based web resource project for Dynamics 365/Power Platform development.

.DESCRIPTION
    This script automates the setup of a complete TypeScript development environment for Dynamics 365
    web resources. It creates a project structure with proper tooling including TypeScript, esbuild for
    bundling, Jest for testing, and all necessary type definitions. The script also generates example
    files demonstrating best practices for form scripts and utilities.

.PARAMETER webresource_folder_name
    The name of the web resource project folder to create. Defaults to "d365-webresources".

.PARAMETER webresource_folder_location
    The parent directory path where the project folder will be created. This parameter is mandatory.
    Example: "C:\Projects\D365\"

.EXAMPLE
    .\initWebresourceProject.ps1 -webresource_folder_location "C:\Projects\D365\"

    Creates a new project at C:\Projects\d365-webresources with the default folder name.

.EXAMPLE
    .\initWebresourceProject.ps1 -webresource_folder_name "Webresources" -webresource_folder_location "C:\Projects\D365\"

    Creates a new project at C:\Projects\D365\Webresources with a custom folder name.

.NOTES
    Author: Krzysztof Balcerowski
    Prerequisites:
        - Node.js and npm must be installed
        - Git should be installed (for .gitignore to be useful)
        - Internet connection required for npm package installation

    The script will:
        1. Create project directory structure
        2. Initialize npm package
        3. Install TypeScript and build tools
        4. Install D365 type definitions
        5. Configure testing framework
        6. Generate example TypeScript files
        7. Run initial build and tests to verify setup
#>
[CmdletBinding()]
param(
    [Parameter(
        HelpMessage = "Name of the web resource project folder (default: d365-webresources)"
    )]
    [ValidateNotNullOrEmpty()]
    [string]$webresource_folder_name = "d365-webresources",

    [Parameter(
        Mandatory = $true,
        HelpMessage = "Parent directory path where the project will be created"
    )]
    [ValidateNotNullOrEmpty()]
    [string]$webresource_folder_location
)

# Step 1: Create project directory
$workingdir = "$webresource_folder_location/$webresource_folder_name"

New-Item -Path "$workingdir" -ItemType "Directory"

cd $workingdir

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
npm install --save-dev jest
npm install --save-dev ts-jest
npm install --save-dev @types/jest
npm install --save-dev xrm-mock 
npx ts-jest config:init
# Step 6: Create TypeScript configuration file and define build script in package.json
npx tsc --init
npm pkg set scripts.build="node build.mjs"
npm pkg set scripts.test="jest"

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

# Step 10: Adding content to created files...

#example contact form

$contact_form_content = 'import { Utilities } from "../shared/utilities";

export class ContactForm {

    private readonly _formContext:Xrm.FormContext;
    private readonly _utilities:Utilities;

    private static _form:ContactForm

    constructor(formContext:Xrm.FormContext){
        this._formContext = formContext;

        this._utilities = new Utilities(Xrm);
    }

    private onLoad(){
        //logic;
    }
    
    //for registration in make.powerapps.com pass ContactForm.onLoad 
    //pass execution context
    public static onLoad(executionContext:Xrm.Events.EventContext){
            this._form = new ContactForm(executionContext.getFormContext());
            this._form.onLoad();
    }
}'

Set-Content -Path "src/forms/contactForm.ts" -Value $contact_form_content

$utilities_content = "//Expose utilities functions, wraps Xrm static object
export class Utilities {

     private readonly _xrm:Xrm.XrmStatic;
     private readonly _api:Xrm.WebApi;

     constructor(xrm:Xrm.XrmStatic){
        this._xrm = xrm;
        this._api = xrm.WebApi;
    }

    public get Api() {
        return this._api;
    }
}"

Set-Content -Path "src/shared/utilities.ts" -Value $utilities_content

#esbuild script
$esbuild_mjs = "import * as esbuild from 'esbuild'

const entryPoints = [{path:'src/forms/contactForm.ts',out:'dist/contactForm.js'}]

entryPoints.forEach(async entry=>{
  await esbuild.build({
  entryPoints: [entry.path],
  bundle: true,
  outfile: entry.out,
  });
});"

New-Item -Path "build.mjs" -ItemType "File"
Add-Content -Path "build.mjs" -Value $esbuild_mjs

#tsconfig.js
$tsconfig_js = '{
  // Visit https://aka.ms/tsconfig to read more about this file
  "compilerOptions": {
    // File Layout
    "rootDir": "./src",
    "outDir": "./dist",
    // Environment Settings
    // See also https://aka.ms/tsconfig/module
    "module": "nodenext",
    "target": "es2019", //max supported version by solution checker
    "types": ["xrm","jest"],
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
    "skipLibCheck": true
  },
  "include": [
    "src/**/*.ts",
    "__tests__/**/*.spec.ts"
  ]
}
'

Set-Content -Path "tsconfig.json" -Value $tsconfig_js

# Step 11: Creating unit test project
New-Item -Path __tests__/forms -ItemType "Directory"
New-Item -Path "__tests__/forms/contactForm.spec.ts" -ItemType "File"

$contactForm_spec_content='import { ContactForm } from "../../src/forms/contactForm";
import { XrmMockGenerator } from "xrm-mock";

describe("ContactForm.onLoad",()=>{

    beforeAll(()=>{
         XrmMockGenerator.initialise();
    });

    test("should execute successfully when valid executionContext is provided",()=>{
        
        const executionContext = XrmMockGenerator.getEventContext();

        Xrm.Navigation.openAlertDialog = jest.fn().mockResolvedValue(true);

        const form = ContactForm.onLoad(executionContext);

        expect(Xrm.Navigation.openAlertDialog).toHaveBeenCalledTimes(1);
    });
});
'

Set-Content -Path "__tests__/forms/contactForm.spec.ts" -Value $contactForm_spec_content

# Last step validating content

npm run build

npm run test

Write-Host "Done"


# SIG # Begin signature block
# MIIQRwYJKoZIhvcNAQcCoIIQODCCEDQCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUc2soHb89REobkiK30CsJPM9e
# Sdeggg0mMIIGZTCCBE2gAwIBAgIQI5uZal2o43X1yypn4EdRLzANBgkqhkiG9w0B
# AQsFADBWMQswCQYDVQQGEwJQTDEhMB8GA1UEChMYQXNzZWNvIERhdGEgU3lzdGVt
# cyBTLkEuMSQwIgYDVQQDExtDZXJ0dW0gQ29kZSBTaWduaW5nIDIwMjEgQ0EwHhcN
# MjUxMTA1MTc1MTE5WhcNMjYxMTA1MTc1MTE4WjCBijELMAkGA1UEBhMCUEwxEjAQ
# BgNVBAgMCXBvbW9yc2tpZTEQMA4GA1UEBwwHR2RhxYRzazEeMBwGA1UECgwVT3Bl
# biBTb3VyY2UgRGV2ZWxvcGVyMTUwMwYDVQQDDCxPcGVuIFNvdXJjZSBEZXZlbG9w
# ZXIsIEtyenlzenRvZiBCYWxjZXJvd3NraTCCAaIwDQYJKoZIhvcNAQEBBQADggGP
# ADCCAYoCggGBALTvW4IkKVVx9OwwLJHbxBVv8vO2IhDLEp1Hl1SN7dZrD9Ipw3PQ
# ZdaUHVmXQ+MmPSVQooD7mgamvrgk69BB148b21fkbac2jJLdZH8sZvrJuLjXvKlI
# viiJAZtnAeBJlOmEK4kxqDaLjrXjP2Y+Xs3ja5xsecItYrBXsl8uqOVw9LohJAqp
# /isrHsdTNrr/s33RTG8vgQzZ8Jo9UEgwa0pvexDMDNO/5YvAfvHzP6Z0vGn4O7vv
# JYyfVisHw2oNHix00yUyOjzudoUiSLdtwFgPW/8wkyxp0ipI28JOtTgKGMGDnqml
# hE6kwMXqGDPkmOIRh+tjaLEbP0C6rks6c/h4cIZc8XcUF5p4ykJCg+Wq4/9WJ0Dg
# KlWSsg47WLkdsHP7Zc56ry7Apk3JrcwPR6YbPKAdC8WJBgLfwRcqtcCGKqI6y6AS
# /EbTcK8PY4RZuyJCAc5GyJlb+W2O9dc8N7Z8gUSZ5oc9CKVDJe1Pl+w4E8KYmCiM
# kuBzqPsFl80XjQIDAQABo4IBeDCCAXQwDAYDVR0TAQH/BAIwADA9BgNVHR8ENjA0
# MDKgMKAuhixodHRwOi8vY2NzY2EyMDIxLmNybC5jZXJ0dW0ucGwvY2NzY2EyMDIx
# LmNybDBzBggrBgEFBQcBAQRnMGUwLAYIKwYBBQUHMAGGIGh0dHA6Ly9jY3NjYTIw
# MjEub2NzcC1jZXJ0dW0uY29tMDUGCCsGAQUFBzAChilodHRwOi8vcmVwb3NpdG9y
# eS5jZXJ0dW0ucGwvY2NzY2EyMDIxLmNlcjAfBgNVHSMEGDAWgBTddF1MANt7n6B0
# yrFu9zzAMsBwzTAdBgNVHQ4EFgQU6hItDpvgkfj6U9KoNa8zIC1Nr1gwSwYDVR0g
# BEQwQjAIBgZngQwBBAEwNgYLKoRoAYb2dwIFAQQwJzAlBggrBgEFBQcCARYZaHR0
# cHM6Ly93d3cuY2VydHVtLnBsL0NQUzATBgNVHSUEDDAKBggrBgEFBQcDAzAOBgNV
# HQ8BAf8EBAMCB4AwDQYJKoZIhvcNAQELBQADggIBAFW51BddGQOPDDn2qq0Uk3iy
# 0FSt2XAy3h1gWSDhVtav4jNJoQ11N7Ebq+EM87CuUx8vOCLrNkPmv240BT0EytDo
# VHo/fqcqjMVCBsaqA4wyZMjPXA5VBw2b50nkoMbSPZ3g8prfjMcElrU9cLVuI2YE
# pXEOiUK6ljzwpYKRafWRPw3IvBW52R6fJ1x/acSXn/N14EZgLi0aigqRIW13YU1i
# z+J/xRTJHMKtSkuaqfgUYCOGKD6ccjSY7NQt1TN+FJyAl+s0BksJilCUuNv11Ipu
# GMFinoGVeAjIdlcckxqfSTgbWzCDqpIXpEVluGGAqtpHj3YmjcMxQju+CuW42A6m
# kigiUdD1SYenj1t3HSThj0vTNwCfKqJ8kvXSkYcKz5hpmgOUqdGqq8BKJAC6E8gH
# /3WKVXGcREIP684PwS224aXstjyYcSA2bep/iju3JPunepe+Ke376C/OpiXGtSVK
# VHYf9pz1/wfp5W9J1TVmWUthm1YpXuoupwNLlOrn1zs61naUpM/3IQ/m7pY+rpdu
# xNWCpTL5EcTkuA7+GjZTPKPIB6mScgSJvN971d+bwXr0Vh7QL1efcOFctXSp16gi
# SEVRj8WoKr7pTVmV14E9DwAgg7kchzQ2+3TwGHD0g6DEiwBQU1JSDK796stx/3RT
# GL7ZC7nypfTzLQ5RLNgGMIIGuTCCBKGgAwIBAgIRAJmjgAomVTtlq9xuhKaz6jkw
# DQYJKoZIhvcNAQEMBQAwgYAxCzAJBgNVBAYTAlBMMSIwIAYDVQQKExlVbml6ZXRv
# IFRlY2hub2xvZ2llcyBTLkEuMScwJQYDVQQLEx5DZXJ0dW0gQ2VydGlmaWNhdGlv
# biBBdXRob3JpdHkxJDAiBgNVBAMTG0NlcnR1bSBUcnVzdGVkIE5ldHdvcmsgQ0Eg
# MjAeFw0yMTA1MTkwNTMyMThaFw0zNjA1MTgwNTMyMThaMFYxCzAJBgNVBAYTAlBM
# MSEwHwYDVQQKExhBc3NlY28gRGF0YSBTeXN0ZW1zIFMuQS4xJDAiBgNVBAMTG0Nl
# cnR1bSBDb2RlIFNpZ25pbmcgMjAyMSBDQTCCAiIwDQYJKoZIhvcNAQEBBQADggIP
# ADCCAgoCggIBAJ0jzwQwIzvBRiznM3M+Y116dbq+XE26vest+L7k5n5TeJkgH4Cy
# k74IL9uP61olRsxsU/WBAElTMNQI/HsE0uCJ3VPLO1UufnY0qDHG7yCnJOvoSNbI
# bMpT+Cci75scCx7UsKK1fcJo4TXetu4du2vEXa09Tx/bndCBfp47zJNsamzUyD7J
# 1rcNxOw5g6FJg0ImIv7nCeNn3B6gZG28WAwe0mDqLrvU49chyKIc7gvCjan3GH+2
# eP4mYJASflBTQ3HOs6JGdriSMVoD1lzBJobtYDF4L/GhlLEXWgrVQ9m0pW37KuwY
# qpY42grp/kSYE4BUQrbLgBMNKRvfhQPskDfZ/5GbTCyvlqPN+0OEDmYGKlVkOMen
# DO/xtMrMINRJS5SY+jWCi8PRHAVxO0xdx8m2bWL4/ZQ1dp0/JhUpHEpABMc3eKax
# 8GI1F03mSJVV6o/nmmKqDE6TK34eTAgDiBuZJzeEPyR7rq30yOVw2DvetlmWssew
# AhX+cnSaaBKMEj9O2GgYkPJ16Q5Da1APYO6n/6wpCm1qUOW6Ln1J6tVImDyAB5Xs
# 3+JriasaiJ7P5KpXeiVV/HIsW3ej85A6cGaOEpQA2gotiUqZSkoQUjQ9+hPxDVb/
# Lqz0tMjp6RuLSKARsVQgETwoNQZ8jCeKwSQHDkpwFndfCceZ/OfCUqjxAgMBAAGj
# ggFVMIIBUTAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTddF1MANt7n6B0yrFu
# 9zzAMsBwzTAfBgNVHSMEGDAWgBS2oVQ5AsOgP46KvPrU+Bym0ToO/TAOBgNVHQ8B
# Af8EBAMCAQYwEwYDVR0lBAwwCgYIKwYBBQUHAwMwMAYDVR0fBCkwJzAloCOgIYYf
# aHR0cDovL2NybC5jZXJ0dW0ucGwvY3RuY2EyLmNybDBsBggrBgEFBQcBAQRgMF4w
# KAYIKwYBBQUHMAGGHGh0dHA6Ly9zdWJjYS5vY3NwLWNlcnR1bS5jb20wMgYIKwYB
# BQUHMAKGJmh0dHA6Ly9yZXBvc2l0b3J5LmNlcnR1bS5wbC9jdG5jYTIuY2VyMDkG
# A1UdIAQyMDAwLgYEVR0gADAmMCQGCCsGAQUFBwIBFhhodHRwOi8vd3d3LmNlcnR1
# bS5wbC9DUFMwDQYJKoZIhvcNAQEMBQADggIBAHWIWA/lj1AomlOfEOxD/PQ7bcma
# hmJ9l0Q4SZC+j/v09CD2csX8Yl7pmJQETIMEcy0VErSZePdC/eAvSxhd7488x/Ca
# t4ke+AUZZDtfCd8yHZgikGuS8mePCHyAiU2VSXgoQ1MrkMuqxg8S1FALDtHqnizY
# S1bIMOv8znyJjZQESp9RT+6NH024/IqTRsRwSLrYkbFq4VjNn/KV3Xd8dpmyQiir
# ZdrONoPSlCRxCIi54vQcqKiFLpeBm5S0IoDtLoIe21kSw5tAnWPazS6sgN2oXvFp
# cVVpMcq0C4x/CLSNe0XckmmGsl9z4UUguAJtf+5gE8GVsEg/ge3jHGTYaZ/Myfuj
# E8hOmKBAUkVa7NMxRSB1EdPFpNIpEn/pSHuSL+kWN/2xQBJaDFPr1AX0qLgkXmcE
# i6PFnaw5T17UdIInA58rTu3mefNuzUtse4AgYmxEmJDodf8NbVcU6VdjWtz0e58W
# FZT7tST6EWQmx/OoHPelE77lojq7lpsjhDCzhhp4kfsfszxf9g2hoCtltXhCX6Nq
# sqwTT7xe8LgMkH4hVy8L1h2pqGLT2aNCx7h/F95/QvsTeGGjY7dssMzq/rSshFQK
# LZ8lPb8hFTmiGDJNyHga5hZ59IGynk08mHhBFM/0MLeBzlAQq1utNjQprztZ5vv/
# NJy8ua9AGbwkMWkOMYICizCCAocCAQEwajBWMQswCQYDVQQGEwJQTDEhMB8GA1UE
# ChMYQXNzZWNvIERhdGEgU3lzdGVtcyBTLkEuMSQwIgYDVQQDExtDZXJ0dW0gQ29k
# ZSBTaWduaW5nIDIwMjEgQ0ECECObmWpdqON19csqZ+BHUS8wCQYFKw4DAhoFAKB4
# MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQB
# gjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkE
# MRYEFA2eLWxCINNELVJ8mgyjsG4GcyLHMA0GCSqGSIb3DQEBAQUABIIBgJNADbAr
# ZOs9WndE+bBLbyuYoQOEqi613sQTMXroHMBeOmMSAHoww67yd1nBbPPe29nsZm0u
# Coq1tOA9HjVTRj+oEOyj6Y17JZ5BzKuxOWYY8mrzE9hNdKB5hrIxq5dKFzeOavOs
# Grs6a0VFkvA9ZNg/1fQC6wMhvIVCb2Gs3OT2I4ZZ+RgnFQMrt+GFDSB7LQbg1Mbx
# zIlUeuOQYkyXyG/TfiBVLIQDOfUNqy/VLWc124Ps8XI4ufRX7Q+ymwYtk5PPq/zj
# W4qbYv/wV4un5Rrt8gFnF+tcq/09P0hwgsSHuiGLiikMm71cMUyKkXG9m779YimM
# Xgvw4Y8XkCDYi/dnOrj+3ZWU6YqM53PZqO2M95xSHibpVkTEP840u5Giq80BhaPB
# eRDbb+KgY1SzV3Sp2I/gZ8Mk7UfqECS2aVHYCiw9O5wSzOCCSliCRLumP3CrRDXY
# 9Xv6NhG+7WkedDoS6n9ouRmjuyxVkhg/evjK2k1y0D8YZh39OOiFh946NQ==
# SIG # End signature block
