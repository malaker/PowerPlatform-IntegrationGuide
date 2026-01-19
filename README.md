# Microsoft Power Platform Integration Guide - Code Examples

Welcome! This repository contains all code listings and examples from the book **"Microsoft Power Platform Integration Guide. For Makers, Consultants, Developers, Architects"**. The folder structure mirrors the book's table of contents, making it easy to find the code you need.

**Book details:**

| | |
|---|---|
| **Title** | Microsoft Power Platform Integration Guide |
| **Subtitle** | For Makers, Consultants, Developers, Architects |
| **ISBN** | 978-83-977764-0-1 (print), 978-83-977764-1-8 (ebook) |

## 📖 About This Repository

This repository is designed to complement the book by providing ready-to-use code examples for:
- Authentication and authorization patterns
- Web API and communication protocols
- Client-side scripting and PCF controls
- Power Automate flows and connectors
- Plugins and custom business logic
- Azure service integrations
- Real-world implementation scenarios

## 📋 Prerequisites

Before using the code examples in this repository, ensure you have the following tools and frameworks installed:

### Required Software

| Tool/Framework | Minimum Version | Purpose | Download Link |
|---------------|-----------------|---------|---------------|
| **.NET Framework** | 4.6.2 | Plugin development, custom connectors | [Download](https://dotnet.microsoft.com/download/dotnet-framework) |
| **Node.js** | 14.x or later | PCF controls, web resources | [Download](https://nodejs.org/) |
| **TypeScript** | 4.x or later | PCF controls development | `npm install -g typescript` |
| **Power Platform CLI** | Latest | Environment management, solution deployment | [Download](https://aka.ms/PowerPlatformCLI) |
| **Visual Studio** | 2019 or later | Plugin development, .NET projects | [Download](https://visualstudio.microsoft.com/) |
| **Visual Studio Code** | Latest | TypeScript/JavaScript development | [Download](https://code.visualstudio.com/) |

### Optional but Recommended

- **Azure CLI** - For Azure service integration examples ([Download](https://docs.microsoft.com/cli/azure/install-azure-cli))
- **PowerShell 7+** - For automation scripts ([Download](https://github.com/PowerShell/PowerShell))
- **Git** - For version control ([Download](https://git-scm.com/))
- **Postman** - For testing Web API examples ([Download](https://www.postman.com/))

### Power Platform Access

- **Power Platform environment** - Developer or trial environment
- **Azure subscription** - For Azure service examples (free tier available)
- **Microsoft 365 account** - For Power Automate and connector examples

## 🚀 Getting Started

### 1. Clone the Repository

This repository contains all code listings and examples from the book chapters. Use this as your primary reference for the code snippets discussed throughout the book.

```bash
git clone https://github.com/malaker/PowerPlatform-IntegrationGuide
cd "Microsoft Power Platform Integration Guide"
```

### 2. Clone the Power Platform and Azure Lab (Optional)

This separate repository provides Infrastructure as Code (Terraform scripts) to automate Azure and Power Platform environment setup, along with complete implementations of Plugins, Azure Functions, Logic Apps, and Azure Data Factory solutions for hands-on practice.

```bash
git clone https://github.com/malaker/Azure-PowerPlatform-Lab
cd "Azure-PowerPlatform-Lab"
```

## 📁 Repository Structure

The repository follows the book's structure:
```
├── 1. Power Platform Overview/
├── 2. Architecture/
│   ├── 2.1 Authentication and Authorization/
│   ├── 2.2 Communication Protocols/
│   ├── 2.4 Client-side scripting/
│   ├── 2.6 Power Automate/
│   ├── 2.7 Plugins/
│   └── ...
├── 3. Integration Aspects/
│   ├── 3.1 Security/
│   ├── 3.5 Performance/
│   ├── 3.7 Reliability and Resilience/
│   └── ...
├── 4. Azure Services/
│   ├── 4.1 Azure Functions/
│   ├── 4.2 Azure Service Bus/
│   ├── 4.4 Azure API Management/
│   └── ...
└── 5. Real World Examples/
    ├── 5.1 Migrating from on premise to cloud/
    ├── 5.3 Communication widgets/
    └── ...
```

Each folder contains:
- Source code files
- Configuration files
- README with specific instructions
- Sample data (where applicable)

## 📄 License

This code is provided as companion material for the book "Microsoft Power Platform Integration Guide. For Makers, Consultants, Developers, Architects". 

All code examples are under MIT License.


## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/powerplatform-integration-examples/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/powerplatform-integration-examples/discussions)

## 🙏 Acknowledgments

Thank you for purchasing the book. I hope these examples accelerate your learning and implementation journey.