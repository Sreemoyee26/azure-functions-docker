# See ../../../documentation/resolute-chiseled.md.
ARG UBUNTU_RELEASE=26.04
ARG CHISEL_VERSION=v1.5.0

# Add Bash and OpenSSH for App Service terminal and legacy SSH access.
# Remove this stage and the matching final-stage COPY, EXPOSE, and ENTRYPOINT if remote access isn't needed.
FROM ubuntu:${UBUNTU_RELEASE} AS remote-tools
ARG TARGETARCH=amd64
ARG UBUNTU_RELEASE
ARG CHISEL_VERSION
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates openssl && \
    rm -rf /var/lib/apt/lists/*
ADD "https://github.com/canonical/chisel/releases/download/${CHISEL_VERSION}/chisel_${CHISEL_VERSION}_linux_${TARGETARCH}.tar.gz" /tmp/chisel.tar.gz
RUN tar -xzf /tmp/chisel.tar.gz -C /usr/bin && \
    mkdir -p /staging-rootfs && \
    chisel cut --release "ubuntu-${UBUNTU_RELEASE}" --root /staging-rootfs \
        base-files_base \
        base-passwd_data \
        bash_bins \
        coreutils_bins \
        login_bins \
        openssh-server_bins \
        openssh-server_config && \
    useradd --root /staging-rootfs --system --gid nogroup --home-dir /run/sshd --shell /usr/sbin/nologin sshd && \
    root_password="$(openssl passwd -6 -salt appservice 'Docker!')" && \
    printf 'root:%s:0:0:99999:7:::\nsshd:!:0:0:99999:7:::\n' "${root_password}" > /staging-rootfs/etc/shadow && \
    chmod 640 /staging-rootfs/etc/shadow && \
    printf '%s\n' \
        'Port 2222' \
        'ListenAddress 0.0.0.0' \
        'LoginGraceTime 180' \
        'X11Forwarding yes' \
        'PasswordAuthentication yes' \
        'PermitEmptyPasswords no' \
        'PermitRootLogin yes' \
        'UsePAM no' \
        'Subsystem sftp internal-sftp' \
        > /staging-rootfs/etc/ssh/sshd_config && \
    printf '%s\n' \
        '#!/bin/bash' \
        'set -e' \
        'ssh-keygen -A' \
        '/usr/sbin/sshd' \
        'exec /azure-functions-host/Microsoft.Azure.WebJobs.Script.WebHost' \
        > /staging-rootfs/startup.sh && \
    chmod 755 /staging-rootfs/startup.sh

FROM mcr.microsoft.com/dotnet/sdk:11.0 AS build
WORKDIR /src
COPY . .
RUN dotnet publish *.csproj -c Release -o /app/publish

# This image uses a chiseled (minimal) Azure Functions base image.
# It doesn't include the .NET 11 runtime, so the next step copies it in from the official .NET image.
FROM mcr.microsoft.com/azure-functions/dotnet-isolated:4-dotnet-isolated11.0-chiseled AS final
COPY --from=mcr.microsoft.com/dotnet/aspnet:11.0 /usr/share/dotnet /usr/share/dotnet

ENV DOTNET_ROOT=/usr/share/dotnet
ENV PATH="/usr/share/dotnet:${PATH}" \
    FUNCTIONS_WORKER_RUNTIME=dotnet-isolated \
    AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true

COPY --from=remote-tools /staging-rootfs /
COPY --from=build /app/publish /home/site/wwwroot
EXPOSE 80 2222
ENTRYPOINT ["/startup.sh"]
