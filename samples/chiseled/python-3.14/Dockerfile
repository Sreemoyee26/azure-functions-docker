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

FROM python:3.14 AS runtime
WORKDIR /app
COPY requirements.txt .
RUN python -m pip install --target .python_packages/lib/site-packages -r requirements.txt && \
    mkdir -p /runtime-libs && \
    find /usr/local -type f \( -perm /111 -o -name '*.so*' \) -exec ldd {} \; 2>/dev/null \
        | awk '/=> \// { print $(NF - 1) } /^\// { print $1 }' \
        | sort -u \
        | while read -r library; do \
            case "${library}" in \
                /usr/local/*|*/libc.so.*|*/libm.so.*|*/libpthread.so.*|*/libdl.so.*|*/librt.so.*|*/ld-linux-*.so.*) ;; \
                *) cp -L "${library}" "/runtime-libs/$(basename "${library}")" ;; \
            esac; \
        done

FROM mcr.microsoft.com/azure-functions/python:4-python3.14-chiseled
COPY --from=runtime /usr/local /usr/local
COPY --from=runtime /runtime-libs /customer-runtime/lib
ENV LD_LIBRARY_PATH=/customer-runtime/lib:/usr/local/lib \
    PATH="/usr/local/bin:${PATH}" \
    PYTHONPATH=/home/site/wwwroot/.python_packages/lib/site-packages \
    FUNCTIONS_WORKER_RUNTIME=python \
    FUNCTIONS_WORKER_RUNTIME_VERSION=3.14
COPY --from=remote-tools /staging-rootfs /
COPY --from=runtime /app/.python_packages /home/site/wwwroot/.python_packages
COPY . /home/site/wwwroot
EXPOSE 80 2222
ENTRYPOINT ["/startup.sh"]
