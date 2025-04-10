# syntax=docker/dockerfile:1
FROM caddy:latest-builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/mholt/caddy-webdav \
    --with github.com/WeidiDeng/caddy-cloudflare-ip

FROM caddy:latest

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
