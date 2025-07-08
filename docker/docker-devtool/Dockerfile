FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl wget vim git iputils-ping traceroute net-tools dnsutils \
    htop strace lsof nano tmux tree jq zip unzip tar \
    python3 python3-pip make \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Cài AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && ./aws/install && rm -rf aws awscliv2.zip

# Cài kubectl bản mới nhất
RUN curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Tạo user jenkins không root (tùy chọn)
# RUN useradd -m -s /bin/bash jenkins

# USER jenkins
# WORKDIR /home/jenkins

CMD ["/bin/bash"]

