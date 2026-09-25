FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    libredwg-tools \
    python3 \
    python3-pip \
    python3-fastapi \
    python3-uvicorn \
    python3-multipart \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY main.py .

EXPOSE 8080
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
