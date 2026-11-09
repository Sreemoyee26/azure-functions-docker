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

Use the language runtime image that you normally use for restore, compilation, downloads,
archive extraction, and package installation. The samples use the official customer-facing
`.NET`, Node.js, Python, Java, and PowerShell runtime images rather than internal build images.
Copy only the completed runtime and application artifacts into the final Azure Functions
Chiseled stage.

The published base has no shell or package manager, so:

- use multi-stage `COPY --from=...` instructions for runtime files and native dependencies;
- copy the application to `/home/site/wwwroot`;
- prepare any additional operating-system tools in an earlier stage.

The [samples](../samples/chiseled/README.md) show this pattern for every documented runtime.

## Shell and SSH access

The published base image intentionally has:

- no shell;
- no package manager;
- no core utilities such as `ls`, `cp`, or `grep`;
- no `curl` or `wget`;
- no SSH server.

The samples add Bash, core utilities, and OpenSSH from Ubuntu 26.04 package slices by using
[Canonical Chisel](https://documentation.ubuntu.com/chisel/en/latest/). The startup script creates
SSH host keys, starts `sshd` on port 2222, and then starts the Functions host.

For Azure App Service:

- the browser terminal and `az webapp exec` require a shell but don't require an SSH server;
- legacy Kudu WebSSH and `az webapp ssh` can require the SSH server;
- port 2222 is for the App Service SSH integration and should not be published directly;
- the samples use the App Service root password `Docker!`; protect access to the SCM site with
  authentication, authorization, and network restrictions.

See [Open a container shell in Azure App Service](https://learn.microsoft.com/azure/app-service/configure-linux-open-ssh-session)
for the current connection options.

If your app doesn't need interactive shell or legacy SSH access, remove the `remote-tools` stage,
the `COPY --from=remote-tools` instruction, port `2222` from `EXPOSE`, and the custom
`ENTRYPOINT`. The customer image then retains the shell-free startup behavior of the published
base image.

## Vulnerability scanning

The base retains package metadata used by common vulnerability scanners. Scan the final customer
image, not only the Azure Functions base. The customer language runtime, Bash, OpenSSH, and other
copied tools add their own packages and servicing responsibilities.
