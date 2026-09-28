# Resolute Chiseled tags

Resolute Chiseled public tags use the existing Azure Functions runtime repositories and append
`-chiseled` to the runtime tag:

```text
4-<runtime><version>-chiseled
```

These are floating tags. When published, they move to the latest serviced Azure Functions v4
image for that runtime version. Pin a digest when deployment reproducibility is required.

A `-chiseled` tag does not imply that `latest`, `-appservice`, or `-nightly` variants exist.
Support is limited by both the language runtime lifecycle and the Ubuntu Resolute lifecycle, and
can end earlier when an Azure Functions runtime version is retired.

> [!IMPORTANT]
>
> Availability and support state can change during rollout. Check the image registry and Azure
> Functions release guidance before using a sample in production.

<!-- BEGIN GENERATED CHISELED TAGS -->
<!-- Run eng/update-chiseled-docs.ps1 to update this section. -->

| Runtime | Floating public tag | Platform | Sample | State |
| --- | --- | --- | --- | --- |
| .NET isolated 10 | `mcr.microsoft.com/azure-functions/dotnet-isolated:4-dotnet-isolated10.0-chiseled` | linux/amd64 | [samples/chiseled/dotnet-isolated-10/Dockerfile](../samples/chiseled/dotnet-isolated-10/Dockerfile) | available |
| .NET isolated 11 | `mcr.microsoft.com/azure-functions/dotnet-isolated:4-dotnet-isolated11.0-chiseled` | linux/amd64 | [samples/chiseled/dotnet-isolated-11/Dockerfile](../samples/chiseled/dotnet-isolated-11/Dockerfile) | preview |
| Java 25 | `mcr.microsoft.com/azure-functions/java:4-java25-chiseled` | linux/amd64 | [samples/chiseled/java-25/Dockerfile](../samples/chiseled/java-25/Dockerfile) | available |
| Node.js 24 | `mcr.microsoft.com/azure-functions/node:4-node24-chiseled` | linux/amd64 | [samples/chiseled/node-24/Dockerfile](../samples/chiseled/node-24/Dockerfile) | available |
| Node.js 26 | `mcr.microsoft.com/azure-functions/node:4-node26-chiseled` | linux/amd64 | [samples/chiseled/node-26/Dockerfile](../samples/chiseled/node-26/Dockerfile) | available |
| PowerShell 7.6 | `mcr.microsoft.com/azure-functions/powershell:4-powershell7.6-chiseled` | linux/amd64 | [samples/chiseled/powershell-7.6/Dockerfile](../samples/chiseled/powershell-7.6/Dockerfile) | preview |
| Python 3.14 | `mcr.microsoft.com/azure-functions/python:4-python3.14-chiseled` | linux/amd64 | [samples/chiseled/python-3.14/Dockerfile](../samples/chiseled/python-3.14/Dockerfile) | available |
<!-- END GENERATED CHISELED TAGS -->
