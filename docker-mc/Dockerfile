FROM jenkins/inbound-agent:latest

USER root

# Tạo thư mục nếu chưa có
RUN mkdir -p /usr/local/bin

# Cài kubectl bản mới nhất
RUN curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Cài curl, tar, bash nếu thiếu
RUN apt-get update && \
    apt-get install -y curl tar bash && \
    rm -rf /var/lib/apt/lists/*

# Cài mc
RUN curl -O https://dl.min.io/client/mc/release/linux-amd64/mc && \
    chmod +x mc && \
    mv mc /usr/local/bin/mc

USER jenkins

ENTRYPOINT ["sh"]
