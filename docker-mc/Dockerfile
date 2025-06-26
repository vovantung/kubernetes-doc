FROM alpine:latest

RUN apk add --no-cache curl tar bash && \
    curl -O https://dl.min.io/client/mc/release/linux-amd64/mc && \
    chmod +x mc && \
    mv mc /usr/local/bin/

ENTRYPOINT [ "sh" ]
