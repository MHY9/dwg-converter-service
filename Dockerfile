FROM python:3.11-slim-bookworm

# Sistem paketlerini güncelle ve sadece libredwg-tools paketini kur
RUN apt-get update && apt-get install -y --no-install-recommends \
    libredwg-tools \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Python bağımlılıklarını pip ile yükle
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Render varsayılan olarak PORT ortam değişkeni atar (varsayılan: 10000)
ENV PORT=10000
EXPOSE 10000

CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT}"]
