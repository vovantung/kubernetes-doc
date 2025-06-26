FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y curl tar bash && \
    curl -s https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc

ENTRYPOINT [ "bash" ]