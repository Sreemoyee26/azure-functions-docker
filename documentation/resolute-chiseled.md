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
- the ASP.NET shared framework required by the Functions host;
- public root CA certificates and the native libraries supplied by the upstream Chiseled base.

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

The [samples](../samples/chiseled/README.md) show this pattern for every initially supported
runtime.

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
customer-owned image. Application Insights and structured stdout logging remain the preferred
diagnostic paths for a shell-free image.

## User and `/home` behavior

The Azure Functions Chiseled base explicitly runs as `USER 0`. This differs from the upstream
.NET Chiseled default. Root is currently required for the App Service `/home` volume contract and
for host admin APIs that write function metadata under `/home/data`.

Function execution has worked in non-root testing, but portal function discovery failed because
the admin API couldn't write the required metadata. Don't switch the final image to a non-root
user unless you independently validate admin APIs, portal function discovery, and all writable
paths for your hosting configuration.

A volume mounted over all of `/home` masks files baked into `/home/site/wwwroot`. Choose a
deployment and storage layout that either:

- places the application in the mounted content path at deployment time; or
- preserves image-based application content and mounts persistent data at a dedicated subpath.

Test the exact App Service storage settings used by your app. Persistent `/home` behavior has not
been independently validated for every runtime.

## Certificates

The base contains the standard public CA bundle. A customer image can install a private CA in a
tool-bearing stage and copy the completed trust store into the final stage.

Runtime certificate injection through `WEBSITE_LOAD_CERTIFICATES` has not yet been validated for
these images. Don't rely on that path until support is documented in the
[Azure App Service certificate guidance](https://learn.microsoft.com/azure/app-service/configure-ssl-certificate-in-code).

## Vulnerability scanning

The base retains package metadata used by common vulnerability scanners. Scan the final customer
image, not only the Azure Functions base, because the customer language runtime and copied tools
add their own packages and servicing responsibilities.

## Current limitations

- Packages can't be installed from inside the final Chiseled stage.
- Customer Dockerfiles require additional runtime-copy steps.
- Console and SSH scenarios require customer-added tooling.
- Full parity across every trigger, binding, and custom-startup combination is not yet claimed.
- Expanded Node.js customer-image testing encountered unresolved function-discovery behavior.
- An interactive WebSSH command inside the customer container has not been captured in validation.
- `WEBSITE_LOAD_CERTIFICATES` and per-runtime persistent `/home` behavior remain unvalidated.

## Migration checklist

1. Select a [supported `-chiseled` tag](supported-tags.md).
2. Add a donor stage for the customer language runtime.
3. Build or restore the app in a tool-bearing stage.
4. Copy the runtime and app output into the final image.
5. Verify runtime-specific environment variables.
6. Decide whether the customer image needs Bash, BusyBox, SSH, or other tools.
7. Validate `/home` storage settings and portal function discovery.
8. Validate custom certificates, triggers, bindings, logging, and diagnostics used by the app.
9. Scan and regularly rebuild the complete customer image.
