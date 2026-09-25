FROM fedora:39

# Fedora resmi deposundan LibreDWG ve Python araçlarını yükle
RUN dnf install -y \
    libredwg \
    python3 \
    python3-pip \
    && dnf clean all

# dwg2dxf aracının varlığını derleme anında doğrula
RUN dwg2dxf --help > /dev/null

WORKDIR /app

COPY requirements.txt .
RUN pip3 install --no-cache-dir --break-system-packages -r requirements.txt

COPY . .

ENV PORT=10000
EXPOSE 10000

CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT}"]
