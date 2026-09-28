# See ../../../documentation/resolute-chiseled.md.
FROM mcr.microsoft.com/openjdk/jdk:25-ubuntu AS runtime

FROM mcr.microsoft.com/azure-functions/java:4-java25-chiseled
COPY --from=runtime /usr/lib/jvm/msopenjdk-25-amd64 /customer-runtime/java
ENV JAVA_HOME=/customer-runtime/java \
    PATH="/customer-runtime/java/bin:${PATH}" \
    FUNCTIONS_WORKER_RUNTIME=java \
    FUNCTIONS_WORKER_RUNTIME_VERSION=25
COPY . /home/site/wwwroot
