# See ../../../documentation/resolute-chiseled.md.
FROM mcr.microsoft.com/oryx/node:26-ubuntu-resolute-20260904.3 AS runtime

FROM mcr.microsoft.com/azure-functions/node:4-node26-chiseled
COPY --from=runtime /usr/local/bin/node /customer-runtime/bin/node
COPY --from=runtime /usr/lib/x86_64-linux-gnu/libatomic.so.1* /usr/lib/x86_64-linux-gnu/
ENV PATH="/customer-runtime/bin:${PATH}" \
    FUNCTIONS_WORKER_RUNTIME=node \
    FUNCTIONS_WORKER_RUNTIME_VERSION=26
COPY . /home/site/wwwroot
