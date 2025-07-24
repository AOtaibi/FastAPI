# Stage 1: Base - A common foundation
FROM python:3.9-slim-buster as base

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Stage 2: Builder - Install Python dependencies
FROM base as builder

WORKDIR /app

RUN pip install --upgrade pip

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 3: Test - For running linters and unit tests
FROM builder as test

WORKDIR /app

COPY . .

RUN pip install ruff pytest

# Stage 4: Final - The final, slim, production-ready image
FROM base as final

WORKDIR /app

COPY --from=builder /app /app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]