# Azure Functions Resolute Chiseled images

Azure Functions Resolute Chiseled images are minimal public base images for Linux custom
containers. They are based on Ubuntu 26.04 Resolute Chiseled and are intended to reduce the
scanner-visible operating-system dependency set compared with full distribution images.

Minimal images can reduce exposure to unused packages, but they do not make an application
automatically secure. You remain responsible for servicing the language runtime, application
dependencies, and any tools copied into your customer image.

## Image contents

Each runtime-specific image contains:

- the Azure Functions host;
- Extension Bundle v4;
- only the worker for the runtime named by the tag;
- the ASP.NET shared framework required by the Functions host.

The image does **not** contain the customer language runtime or application content. Your
Dockerfile must add both. See the [supported tags](supported-tags.md) and
[runtime samples](../samples/chiseled/README.md).

The initial images target Linux x64. Do not assume another architecture is available unless it is
listed in the supported-tags table.

## Build a customer image

Use a normal tool-bearing image for restore, compilation, downloads, archive extraction, and
package installation. Copy only the completed runtime and application artifacts into the final
Azure Functions Chiseled stage.

The final stage has no shell, so:

- don't use shell-form `RUN`, `CMD`, or `ENTRYPOINT` instructions in that stage;
- use multi-stage `COPY --from=...` instructions for runtime files and native dependencies;
- copy the application to `/home/site/wwwroot`;
- retain the exec-form Functions host entry point supplied by the base image.

The [samples](../samples/chiseled/README.md) show this pattern for every documented runtime.

## Shells, BusyBox, and remote debugging

The published base image intentionally has:

- no shell;
- no package manager;
- no core utilities such as `ls`, `cp`, or `grep`;
- no `curl` or `wget`;
- no SSH server.

For a manually authored image, you can copy
[BusyBox](https://busybox.net/) from a separate build stage when basic shell utilities are
required. BusyBox alone does not enable the Kudu SSH experience. Kudu SSH also requires a
compatible SSH server, configuration, and startup process.

Client-generated Chiseled Dockerfiles can include Bash and the required Kudu tooling in the
customer-owned image.

## Vulnerability scanning

The base retains package metadata used by common vulnerability scanners. Scan the final customer
image, not only the Azure Functions base, because the customer language runtime and copied tools
add their own packages and servicing responsibilities.
