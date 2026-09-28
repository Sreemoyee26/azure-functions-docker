# See ../../../documentation/resolute-chiseled.md.
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY . .
RUN dotnet publish --configuration Release --output /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime

FROM mcr.microsoft.com/azure-functions/dotnet-isolated:4-dotnet-isolated10.0-chiseled
COPY --from=runtime /usr/share/dotnet /customer-runtime/dotnet
ENV DOTNET_ROOT=/customer-runtime/dotnet \
    PATH="/customer-runtime/dotnet:${PATH}" \
    FUNCTIONS_WORKER_RUNTIME=dotnet-isolated \
    FUNCTIONS_WORKER_RUNTIME_VERSION=10.0
COPY --from=build /app/publish /home/site/wwwroot
