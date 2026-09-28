# Azure Functions container samples

The [Resolute Chiseled samples](chiseled/README.md) demonstrate how to add a customer language
runtime and application to a minimal Azure Functions public image.

Use the samples to:

- select a runtime-specific Chiseled tag;
- copy the language runtime from a tool-bearing donor image;
- deploy application content to `/home/site/wwwroot`;
- understand the shell-free, root-user, `/home`, and certificate contracts;
- decide whether your customer image requires optional debugging utilities.

Read the [Resolute Chiseled guidance](../documentation/resolute-chiseled.md) before adapting a
sample, and confirm the tag state in the [supported-tags table](../documentation/supported-tags.md).
