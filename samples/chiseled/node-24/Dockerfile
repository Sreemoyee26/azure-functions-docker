# See ../../../documentation/resolute-chiseled.md.
FROM mcr.microsoft.com/oryx/node:24-ubuntu-noble-20260820.1 AS runtime

FROM mcr.microsoft.com/azure-functions/node:4-node24-chiseled
COPY --from=runtime /usr/local/bin/node /customer-runtime/bin/node
ENV PATH="/customer-runtime/bin:${PATH}" \
    FUNCTIONS_WORKER_RUNTIME=node \
    FUNCTIONS_WORKER_RUNTIME_VERSION=24
COPY . /home/site/wwwroot
