<#
.SYNOPSIS
    Generates self-signed Certificate for nuget package signing required to 
    configure Managed Identity for Power Platfrom Dataverse Plugin Assembly 
    and Plugin Package.Prints out required details for configuring 
    Federated Credentials for User Managed Identity or App Registration.

.DESCRIPTION
    Detailed description of the script's purpose and functionality.
    This section can span multiple lines to provide comprehensive information
    about what the script accomplishes.

.PARAMETER Subject
    [string] Subject to be populated in self-signed certificate. 
    Default: Power Platform Plugin Package Code

.PARAMETER MonthsValid
    [int] Number of months till expiration date. Default 24.

.PARAMETER passwordRaw
    [string] Password to protect private key in self-signed X.509 certificate.
    Default !StrongPassword1@. It is recommended to provide your own password.
    
.PARAMETER pfxLocation
    [string] Location to save X.509 self-signed certificate in pfx format.

.PARAMETER SnkLocation
    [string] Location to save pair of keys in snk format in order to generate strong name for Plugin Assembly.
    When you go with Plugin Package, generating strong name for underlying assemblies are not required.

.PARAMETER TenantId
    [GUID] Azure Directory ID/Tenant ID where User Managed Identity or App Registration is created. 

.PARAMETER EnvironmentId
    [GUID] Power Platform Environment ID (can be optained from PPAC)


.EXAMPLE
    .\Listing2.31.ps1 -tenantId "d0e78ac8-5944-414d-b957-fb5e2ca9b84d" -environmentId "660da186-d3ac-4269-bc56-4e3991aee196"
    Generates self-signed certificate for given Azure Tenant and Power Platform Environment.
    X.509 certificate is protected by default password. Certificate and snk are saved in current folder.

.NOTES
    File Name      : Listing.2.31.ps1
    Author         : Krzysztof Balcerowski
    Created        : 2025-11-05
    Last Modified  : 2025-11-05
    Version        : 1.0.0
    Prerequisite   : PowerShell 5.1 or higher
    Book Title     : Microsoft Power Platform Integration Guide. For Makers, Consultants, Developers, Architects.
    Chapter        : 2. Architecture / 2.7 Plugins
#>
[CmdletBinding()]
param(
    [Parameter()][string]$Subject = "Power Platform Plugin Package Code",
    [Parameter()][string]$MonthsValid=24,
    [Parameter()][string]$PasswordRaw="!StrongPassword1@",
    [Parameter()][string]$PfxLocation="./codesign.pfx",
    [Parameter()][string]$SnkLocation='./key.snk',
    [Parameter(mandatory=$true)][string]$TenantId,
    [Parameter(mandatory=$true)][string]$EnvironmentId
)
#Self Signed Certificate Generation
$cert=New-SelfSignedCertificate -Subject $Subject -KeyUsageProperty All -NotAfter (Get-Date).AddMonths($MonthsValid) -Type CodeSigningCert -KeyUsage DigitalSignature -CertStoreLocation Cert:\CurrentUser\My -KeyAlgorithm 'RSA' -KeyLength 2048 -HashAlgorithm 'SHA256' -KeyExportPolicy Exportable -KeySpec Signature

$cert.RawData

# Get RSA private key
$rsa = [System.Security.Cryptography.X509Certificates.RSACertificateExtensions]::GetRSAPrivateKey($cert)

# Create a new RSACryptoServiceProvider and import the key
$csp = New-Object System.Security.Cryptography.RSACryptoServiceProvider
$csp.ImportParameters($rsa.ExportParameters($true))

# Export as SNK to configure generating Strong Name for plugin Assembly
$snkBytes = $csp.ExportCspBlob($true)
[System.IO.File]::WriteAllBytes($SnkLocation, $snkBytes)

# Create a password for the PFX file
$secureString =  ConvertTo-SecureString $PasswordRaw -AsPlainText -Force

# Export the certificate to a PFX file. File will be used in dotnet nuget sign command to sign nuget package
Export-PfxCertificate -Cert $cert -FilePath $PfxLocation -Password $secureString

# Calculate SHA256 hash from RawData
$sha256 = [System.Security.Cryptography.SHA256]::Create()
$hashBytes = $sha256.ComputeHash($cert.RawData)
$hashString = [System.BitConverter]::ToString($hashBytes).Replace("-", "")

$tenandIdGuid = [System.Guid]::Parse($TenantId)

# Get the byte array (this uses little-endian for the first three components)
$bytes = $tenandIdGuid.ToByteArray()

# Convert to Base64
$base64 = [Convert]::ToBase64String($bytes)

# Convert to Base64URL format
$base64Url = $base64.Replace('+', '-').Replace('/', '_').TrimEnd('=')

Write-Host "SNK file created: $SnkLocation"
Write-Host "PFX file created: $PfxLocation"
Write-Host "Encoded Tenant Id:$base64Url"
Write-Host "SHA256 Hash (lowercase): $($hashString.ToLower())"
Write-Host "Issuer for federated credentials:"
Write-Host "Value for federated credentials:/eid1/c/pub/t/$base64Url/a/qzXoWDkuqUa3l6zM5mM0Rw/n/plugin/e/$EnvironmentId/h/$($hashString.ToLower())"

# SIG # Begin signature block
# MIIQRwYJKoZIhvcNAQcCoIIQODCCEDQCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUjKRcanczCecjz30m1HIHFaXB
# FFSggg0mMIIGZTCCBE2gAwIBAgIQI5uZal2o43X1yypn4EdRLzANBgkqhkiG9w0B
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
# MRYEFLndvJ842NFA69lH371B8cdfsHJmMA0GCSqGSIb3DQEBAQUABIIBgExI0ttK
# L3CG+HKeSYVJt4/EKI2ryAx+C5obt/bVCpaJnY0Vg5LCaRTaWJrIQczMvtPEnH8F
# bYMgYAjDq6OjczcumNRoYZFbC385NiZPrWCtgnVdM8q0bycxH/X/sZQmUn+ySuYR
# 6JgpCTLqs2nDdJWUSu1Y9oSwqd2qFQbmkY3DjjHnR6zUKRiDPLKA7HFuJs9BrpgP
# gSkoSW/BJiek9InRjmgEIq5NrairSU7fwiwnKw1gD9TRAZv9K/J3oR4T4LJi2war
# 0tdZN96FWzwZNF3N0/blbFfinXUe7si5+MXDxVkZOXrR+TMrDNHfg3eLG+viHcqX
# Oa9apCYqAbRpBJHkpSUGykCJshHFt/Xz6zAVwXu6PIh4yNaRWKcNLway/Dag05Ms
# gLWHIDaQ3HfOnWmt2Osl0wFw/CUU6wy/x3UWVHpU7CkSmbpPEijR8+zFA4jIiPd0
# 6iCYCiEpJRMRZAwJ64Sdsd1maN1rmPuFfoMX6CqlNuy4CvPfbG9c1Pr3rg==
# SIG # End signature block
