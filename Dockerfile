# Build stage
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Final runtime stage
FROM python:3.11-slim AS runner
WORKDIR /app
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Copy installed dependencies from builder
COPY --from=builder /root/.local /home/appuser/.local
COPY app.py .

RUN chown -R appuser:appgroup /app
USER appuser
ENV PATH=/home/appuser/.local/bin:$PATH

EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]