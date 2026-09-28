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

For user, storage, certificate, BusyBox, and SSH considerations, see the
[Resolute Chiseled guidance](../../documentation/resolute-chiseled.md).

<!-- BEGIN GENERATED CHISELED SAMPLES -->
<!-- Run eng/update-chiseled-docs.ps1 to update this section. -->

| Runtime | Azure Functions image | Runtime donor | Dockerfile | Notes |
| --- | --- | --- | --- | --- |
| .NET isolated 10 | `mcr.microsoft.com/azure-functions/dotnet-isolated:4-dotnet-isolated10.0-chiseled` | `mcr.microsoft.com/dotnet/aspnet:10.0` | [dotnet-isolated-10/Dockerfile](dotnet-isolated-10/Dockerfile) | Copy the customer .NET runtime separately from the framework used by the Functions host. |
| .NET isolated 11 | `mcr.microsoft.com/azure-functions/dotnet-isolated:4-dotnet-isolated11.0-chiseled` | `mcr.microsoft.com/dotnet/aspnet:11.0-preview` | [dotnet-isolated-11/Dockerfile](dotnet-isolated-11/Dockerfile) | Replace the preview donor with the released .NET 11 tag when available. |
| Java 25 | `mcr.microsoft.com/azure-functions/java:4-java25-chiseled` | `mcr.microsoft.com/openjdk/jdk:25-ubuntu` | [java-25/Dockerfile](java-25/Dockerfile) | The sample copies the Microsoft OpenJDK 25 runtime tree. |
| Node.js 24 | `mcr.microsoft.com/azure-functions/node:4-node24-chiseled` | `mcr.microsoft.com/oryx/node:24-ubuntu-noble-20260820.1` | [node-24/Dockerfile](node-24/Dockerfile) | Pin or update the Oryx donor through this manifest when the supported runtime changes. |
| Node.js 26 | `mcr.microsoft.com/azure-functions/node:4-node26-chiseled` | `mcr.microsoft.com/oryx/node:26-ubuntu-resolute-20260904.3` | [node-26/Dockerfile](node-26/Dockerfile) | The current donor also requires libatomic.so.1 to be copied into the final image. |
| PowerShell 7.6 | `mcr.microsoft.com/azure-functions/powershell:4-powershell7.6-chiseled` | `mcr.microsoft.com/powershell:preview-7.6-ubuntu-noble` | [powershell-7.6/Dockerfile](powershell-7.6/Dockerfile) | Replace the preview donor with the released PowerShell 7.6 tag when available. |
| Python 3.14 | `mcr.microsoft.com/azure-functions/python:4-python3.14-chiseled` | `mcr.microsoft.com/oryx/python:3.14-ubuntu-noble-20260820.1` | [python-3.14/Dockerfile](python-3.14/Dockerfile) | Install application dependencies into .python_packages before the final stage. |
<!-- END GENERATED CHISELED SAMPLES -->
