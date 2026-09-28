# See ../../../documentation/resolute-chiseled.md.
FROM mcr.microsoft.com/oryx/python:3.14-ubuntu-noble-20260820.1 AS runtime

FROM runtime AS dependencies
WORKDIR /app
COPY requirements.txt .
RUN /opt/python/3/bin/python -m pip install --target .python_packages/lib/site-packages -r requirements.txt

FROM mcr.microsoft.com/azure-functions/python:4-python3.14-chiseled
COPY --from=runtime /opt/python /opt/python
ENV LD_LIBRARY_PATH=/opt/python/3/lib \
    PATH="/opt/python/3/bin:${PATH}" \
    PYTHONPATH=/home/site/wwwroot/.python_packages/lib/site-packages \
    FUNCTIONS_WORKER_RUNTIME=python \
    FUNCTIONS_WORKER_RUNTIME_VERSION=3.14
COPY --from=dependencies /app/.python_packages /home/site/wwwroot/.python_packages
COPY . /home/site/wwwroot
