
# Stage 1: Application Image
FROM python:3.9-slim-buster as app-image
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]

# Stage 2: Scanner Image
FROM python:3.9-slim-buster as scanner
WORKDIR /workspace

# Install bandit with SARIF support
RUN pip install --upgrade pip && \
    pip install "bandit[sarif]>=1.7.0"

# Copy source code to be scanned
COPY . .
