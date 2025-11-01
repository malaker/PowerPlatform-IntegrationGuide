# Appendix - Power Platform Subnet Delegation Subnet Calculator Example

---
##
Calculator - https://github.com/malaker/Books/blob/main/Microsoft%20Power%20Platform%20Integration%20Guide/2.%20Architecture/2.9%20Networking%20and%20Data%20Gateways/2.9.2%20Subnet%20Delegation/PowerPlatform_SubnetDelegationCalculator.xlsx

## 🔧 Hard Requirements (11/12/2025)

| Requirement | Value |
|-------------|------:|
| **Number of IP Address for PROD environment** | 30 |
| **Number of IP Address for NON-PROD environment** | 10 |
| **Reserved IP Addresses per SUBNET** | 5 |

## 📊 Calculator Parameters

| Parameter | Value |
|-----------|------:|
| Number of makers (Individual environments) | 200 |
| Number of non-production environments (Excluding individual for makers, e.g. shared environments not requiring isolation) | 10 |
| Number of isolated non-production environments | 8 |
| Number of production environments not requiring isolation | 4 |
| Number of isolated production environments | 8 |
| Extra Subnet Buffer Non-Prod Capacity | 64 |
| Extra Subnet Buffer Prod Capacity | 256 |

---

## 🌐 Non-Production Environment

### Virtual Network Configuration
- **Network CIDR:** 10.100.0.0/16
- **Network Range:** 10.100.0.0 - 10.100.255.255
- **Total Addresses:** 65,536

### Subnets (No Isolation Per Environment)

| Subnet Name | Subnet Address | CIDR | Subnet Mask | Usable Hosts | Address Range |
|-------------|----------------|------|-------------|-------------:|---------------|
| subnet-for-makers | 10.100.0.0 | /21 | 255.255.248.0 | 2,046 | 10.100.0.1 - 10.100.7.254 |
| subnet-for-non-prod (no isolation) | 10.100.8.0 | /22 | 255.255.252.0 | 1,022 | 10.100.8.1 - 10.100.11.254 |

### Subnets for Isolated Environments

| Subnet # | Subnet Address | CIDR | Subnet Mask | Usable Hosts | Address Range |
|---------:|----------------|------|-------------|-------------:|---------------|
| 1 | 10.100.12.0 | /25 | 255.255.255.128 | 126 | 10.100.12.1 - 10.100.12.126 |
| 2 | 10.100.12.128 | /25 | 255.255.255.128 | 126 | 10.100.12.129 - 10.100.12.254 |
| 3 | 10.100.13.0 | /25 | 255.255.255.128 | 126 | 10.100.13.1 - 10.100.13.126 |
| 4 | 10.100.13.128 | /25 | 255.255.255.128 | 126 | 10.100.13.129 - 10.100.13.254 |
| 5 | 10.100.14.0 | /25 | 255.255.255.128 | 126 | 10.100.14.1 - 10.100.14.126 |
| 6 | 10.100.14.128 | /25 | 255.255.255.128 | 126 | 10.100.14.129 - 10.100.14.254 |
| 7 | 10.100.15.0 | /25 | 255.255.255.128 | 126 | 10.100.15.1 - 10.100.15.126 |
| 8 | 10.100.15.128 | /25 | 255.255.255.128 | 126 | 10.100.15.129 - 10.100.15.254 |

---

## 🏭 Production Environment

### Virtual Network Configuration
- **Network CIDR:** 10.10.0.0/16
- **Network Range:** 10.10.0.0 - 10.10.255.255
- **Total Addresses:** 65,536

### Subnets (No Isolation Per Environment)

| Subnet Name | Subnet Address | CIDR | Subnet Mask | Usable Hosts | Address Range |
|-------------|----------------|------|-------------|-------------:|---------------|
| subnet-for-prod (no isolation) | 10.10.0.0 | /21 | 255.255.248.0 | 2,046 | 10.10.0.1 - 10.10.7.254 |

### Subnets for Isolated Environments

| Subnet # | Subnet Address | CIDR | Subnet Mask | Usable Hosts | Address Range |
|---------:|----------------|------|-------------|-------------:|---------------|
| 1 | 10.10.8.0 | /23 | 255.255.254.0 | 510 | 10.10.8.1 - 10.10.9.254 |
| 2 | 10.10.10.0 | /23 | 255.255.254.0 | 510 | 10.10.10.1 - 10.10.11.254 |
| 3 | 10.10.12.0 | /23 | 255.255.254.0 | 510 | 10.10.12.1 - 10.10.13.254 |
| 4 | 10.10.14.0 | /23 | 255.255.254.0 | 510 | 10.10.14.1 - 10.10.15.254 |
| 5 | 10.10.16.0 | /23 | 255.255.254.0 | 510 | 10.10.16.1 - 10.10.17.254 |
| 6 | 10.10.18.0 | /23 | 255.255.254.0 | 510 | 10.10.18.1 - 10.10.19.254 |
| 7 | 10.10.20.0 | /23 | 255.255.254.0 | 510 | 10.10.20.1 - 10.10.21.254 |
| 8 | 10.10.22.0 | /23 | 255.255.254.0 | 510 | 10.10.22.1 - 10.10.23.254 |

---

## 📋 Network Allocation Summary

### Non-Production Total Allocation
- **Total IPs Allocated:** 4,096 out of 65,536 (6.25%)
- **Available IPs:** 61,440

### Production Total Allocation
- **Total IPs Allocated:** 6,144 out of 65,536 (9.38%)
- **Available IPs:** 59,392

---

*Document generated from Excel spreadsheet with calculated subnet addresses*
*All subnet addresses are non-overlapping and properly aligned to their CIDR boundaries*

*Reference: https://learn.microsoft.com/en-us/power-platform/admin/vnet-support-overview*