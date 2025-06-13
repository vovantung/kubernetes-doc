FROM jenkins/jenkins:lts

USER root

# Cài đặt các gói cần thiết
RUN apt-get update && apt-get install -y \
    git maven curl unzip dnsutils apt-transport-https \
    ca-certificates gnupg lsb-release software-properties-common \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# Cài awscli v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && ./aws/install && \
    rm -rf aws awscliv2.zip

# Cài kubectl bản mới nhất
RUN curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Copy entrypoint script vào container
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Dùng entrypoint mới
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

ENTRYPOINT ["/usr/local/bin/jenkins.sh"]

USER jenkins
