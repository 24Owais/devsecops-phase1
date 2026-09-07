# Stage 1: Build dependencies
# Change from python:3.11-slim to an updated patch tag or modern slim image
FROM python:3.11.8-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Minimal, secure runtime
FROM python:3.11-slim AS runner
WORKDIR /app

# Security Rule: Run as non-root user
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

COPY --from=builder /root/.local /home/appuser/.local
COPY app.py .

RUN chown -R appuser:appgroup /app
ENV PATH=/home/appuser/.local/bin:$PATH

USER appuser

EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]