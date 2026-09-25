FROM python:3.11-alpine

# LibreDWG ve dwg2dxf aracını Alpine resmi deposundan tek adımda kur
RUN apk add --no-cache \
    libredwg \
    libredwg-tools

# dwg2dxf aracının başarıyla kurulduğunu derleme esnasında doğrula
RUN dwg2dxf --help > /dev/null

WORKDIR /app

# Python bağımlılıklarını kur
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Render port ayarı
ENV PORT=10000
EXPOSE 10000

CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT}"]
