# Microsoft Power Platform Integration Guide - Code Examples

Welcome! This repository contains all code listings and examples from the book **"Microsoft Power Platform Integration Guide. For Makers, Consultants, Developers, Architects"**. The folder structure mirrors the book's table of contents, making it easy to find the code you need.

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
```bash
git clone https://github.com/malaker/Books.git
cd "Microsoft Power Platform Integration Guide"
```

### 2. Verify Prerequisites

Run the following commands to verify your installations:
```bash
# Check .NET Framework version
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" /v Version

# Check Node.js version
node --version

# Check TypeScript version
tsc --version

# Check Power Platform CLI
pac

# Check Azure CLI (if installed)
az --version
```

### 3. Install Node.js Dependencies

For PCF controls and web resources examples:
```bash
cd "2. Architecture/2.4 Client-side scripting/2.4.2 PCF Controls"
npm install
```

### 4. Restore .NET Packages

For plugin and .NET examples:
```bash
cd "2. Architecture/2.7 Plugins"
dotnet restore
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



## 🔒 Security Best Practices

⚠️ **Important Security Notes:**

1. **Never commit secrets** - Use `.env` files and add them to `.gitignore`
2. **Use managed identities** - Where possible in Azure services
3. **Rotate credentials** - Regularly update client secrets and connection strings
4. **Principle of least privilege** - Grant minimal required permissions
5. **Secure local development** - Use Azure Key Vault or similar for local dev secrets

## 🐛 Troubleshooting

### Common Issues

**Issue: Plugin registration fails**
```
Solution: Ensure your assembly is signed and targets .NET Framework 4.6.2
```

**Issue: PCF control build errors**
```bash
# Clear node modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

**Issue: Authentication failures**
```
Solution: Verify your app registration has the correct API permissions
- Dynamics CRM API: user_impersonation
- Check redirect URIs match your configuration
```

**Issue: .NET Framework 4.6.2 not found**
```
Solution: Download and install from: https://dotnet.microsoft.com/download/dotnet-framework/net462
```

## 📖 Chapter-Specific Guides

Each major section includes detailed README files:

- **[Chapter 2: Architecture](./2.%20Architecture/README.md)** - Plugin development, authentication patterns
- **[Chapter 3: Integration Aspects](./3.%20Integration%20Aspects/README.md)** - Performance optimization, monitoring
- **[Chapter 4: Azure Services](./4.%20Azure%20Services/README.md)** - Azure integration examples
- **[Chapter 5: Real World Examples](./5.%20Real%20World%20Examples/README.md)** - Complete implementation scenarios

## 🤝 Contributing

Found an issue or have an improvement? Contributions are welcome!

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit your changes (`git commit -am 'Add new example'`)
4. Push to the branch (`git push origin feature/improvement`)
5. Create a Pull Request

## 📄 License

This code is provided as companion material for the book "Microsoft Power Platform Integration Guide. For Makers, Consultants, Developers, Architects". 

All code examples are under MIT License.


## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/powerplatform-integration-examples/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/powerplatform-integration-examples/discussions)
- **Author Contact**: [Your email or social media]

## 🙏 Acknowledgments

Thank you for purchasing the book. I hope these examples accelerate your learning and implementation journey.