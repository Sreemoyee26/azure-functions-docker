# See ../../../documentation/resolute-chiseled.md.
FROM mcr.microsoft.com/powershell:preview-7.6-ubuntu-noble AS runtime

FROM mcr.microsoft.com/azure-functions/powershell:4-powershell7.6-chiseled
COPY --from=runtime /opt/microsoft/powershell/7-preview /customer-runtime/powershell
ENV PATH="/customer-runtime/powershell:${PATH}" \
    FUNCTIONS_WORKER_RUNTIME=powershell \
    FUNCTIONS_WORKER_RUNTIME_VERSION=7.6
COPY . /home/site/wwwroot
