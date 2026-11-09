# Azure Functions container samples

The [Resolute Chiseled samples](chiseled/README.md) demonstrate how to add a customer language
runtime and application to a minimal Azure Functions public image.

Use the samples to:

- select a runtime-specific Chiseled tag;
- copy the language runtime from its customer-facing runtime image;
- deploy application content to `/home/site/wwwroot`;
- add Bash and OpenSSH when interactive access is required.

Read the [Resolute Chiseled guidance](../documentation/resolute-chiseled.md) before adapting a
sample, and confirm the tag state in the [supported-tags table](../documentation/supported-tags.md).
