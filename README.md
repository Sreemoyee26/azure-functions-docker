
> **⚠️ Important Update – May 2025**
>
> The Dockerfile source files for Azure Functions base images have been moved to an internal Microsoft repository and are no longer maintained in this public repo.
> Public base images will continue to be published and updated monthly with the latest runtime and security patches. This change **does not impact** custom container function apps.
> If you're building your own containers, please ensure you:
>
> - Use the latest supported images from the [MCR](https://mcr.microsoft.com/en-us/catalog?search=%22azure%20functions%22&type=exact) / [Docker Hub](https://hub.docker.com/r/microsoft/azure-functions).
> - Regularly update and redeploy your containers to stay current with runtime and security updates. See [Build a containerized function app](https://learn.microsoft.com/en-us/azure/azure-functions/functions-how-to-custom-container?tabs=core-tools%2Cacr%2Cazure-cli2%2Cazure-cli&pivots=azure-functions) for details.

# Azure Functions public images

Azure Functions public images remain available from
[Microsoft Artifact Registry](https://mcr.microsoft.com/en-us/catalog?search=%22azure%20functions%22&type=exact).
The production Dockerfile sources are maintained internally, while this repository provides
customer-facing guidance and examples.

## Image variants

Resolute Chiseled images are an opt-in, minimal variant for custom containers. Each image contains
the Functions host, Extension Bundle v4, and the selected language worker, but it does not contain
the customer language runtime or application. The final image is shell-free and has no package
manager.

- [Resolute Chiseled image guidance](documentation/resolute-chiseled.md)
- [Supported Resolute Chiseled tags](documentation/supported-tags.md)
- [Customer Dockerfile samples](samples/README.md)
