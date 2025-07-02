FROM bitnami/minideb:latest

RUN install_packages curl bash tar ca-certificates wget unzip

# Cài đặt kubectl v1.30.1 trực tiếp (có thể thay bằng version bạn muốn)
RUN curl -LO https://dl.k8s.io/release/v1.30.1/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

# Cài đặt MinIO Client (mc)
RUN curl -Lo /usr/local/bin/mc https://dl.min.io/client/mc/release/linux-amd64/mc && \
    chmod +x /usr/local/bin/mc

WORKDIR /app

ENTRYPOINT ["sh"]
