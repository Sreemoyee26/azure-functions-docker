# Resolute Chiseled customer Dockerfiles

These Dockerfiles are starting points for existing Azure Functions application projects. They use
tool-bearing build or runtime-donor stages and keep the final Azure Functions stage shell-free.

Build a sample from the application project directory by naming its Dockerfile:

```console
docker build -f path/to/Dockerfile -t my-function-app .
```

The documented Azure Functions tags currently resolve in Microsoft Artifact Registry. Confirm
their support state and the availability of the runtime donor before building. Customers own the
servicing of the donor runtime and all application dependencies.

For image composition and shell-free build guidance, see the
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
