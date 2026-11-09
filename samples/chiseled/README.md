# Resolute Chiseled customer Dockerfiles

These Dockerfiles are starting points for existing Azure Functions application projects. They use
the same customer-facing runtime images that you would normally use for each language. They also
show how to add Bash, core utilities, and OpenSSH to the Chiseled final image for App Service
terminal and legacy SSH access.

Build a sample from the application project directory by naming its Dockerfile:

```console
docker build -f path/to/Dockerfile -t my-function-app .
```

The documented Azure Functions tags currently resolve in Microsoft Artifact Registry, except for
tags marked as planned in the [supported-tags table](../../documentation/supported-tags.md).
Confirm the tag state before building. Customers own the servicing of the copied language
runtime, remote-access tools, and application dependencies.

Each sample:

1. Builds a small Ubuntu 26.04 tools filesystem with Bash, core utilities, and OpenSSH.
2. Copies the customer language runtime into the Azure Functions Chiseled image.
3. Copies the app to `/home/site/wwwroot`.
4. Starts OpenSSH on port 2222 and then starts the Functions host.

The browser terminal and `az webapp exec` need Bash but don't need the SSH server. If you don't
need legacy SSH access, follow the removal steps in the
[shell and SSH guidance](../../documentation/resolute-chiseled.md#shell-and-ssh-access).

For image composition and remote-access guidance, see the
[Resolute Chiseled guidance](../../documentation/resolute-chiseled.md).

| Runtime | Azure Functions image | Dockerfile |
| --- | --- | --- |
| .NET isolated 10 | `mcr.microsoft.com/azure-functions/dotnet-isolated:4-dotnet-isolated10.0-chiseled` | [dotnet-isolated-10/Dockerfile](dotnet-isolated-10/Dockerfile) |
| .NET isolated 11 | `mcr.microsoft.com/azure-functions/dotnet-isolated:4-dotnet-isolated11.0-chiseled` | [dotnet-isolated-11/Dockerfile](dotnet-isolated-11/Dockerfile) |
| Java 25 | `mcr.microsoft.com/azure-functions/java:4-java25-chiseled` | [java-25/Dockerfile](java-25/Dockerfile) |
| Node.js 24 | `mcr.microsoft.com/azure-functions/node:4-node24-chiseled` | [node-24/Dockerfile](node-24/Dockerfile) |
| Node.js 26 | `mcr.microsoft.com/azure-functions/node:4-node26-chiseled` | [node-26/Dockerfile](node-26/Dockerfile) |
| PowerShell 7.6 | `mcr.microsoft.com/azure-functions/powershell:4-powershell7.6-chiseled` | [powershell-7.6/Dockerfile](powershell-7.6/Dockerfile) |
| Python 3.14 | `mcr.microsoft.com/azure-functions/python:4-python3.14-chiseled` | [python-3.14/Dockerfile](python-3.14/Dockerfile) |
| Python 3.15 | `mcr.microsoft.com/azure-functions/python:4-python3.15-chiseled` | [python-3.15/Dockerfile](python-3.15/Dockerfile) |
