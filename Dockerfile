
# Stage 1: Builder - for the final application image
FROM python:3.9-slim-buster as builder

WORKDIR /workspace

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Stage 2: Scanner - for running security scans
FROM python:3.9-slim-buster as scanner

WORKDIR /workspace

COPY requirements.txt .
COPY app/ app/

RUN pip install bandit safety

CMD ["/bin/bash"]
