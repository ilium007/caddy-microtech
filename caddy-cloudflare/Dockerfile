# syntax=docker/dockerfile:1
FROM caddy:2.9.1-builder AS builder

RUN xcaddy build \
    #--with github.com/caddy-dns/cloudflare \
    #--with github.com/caddy-dns/cloudflare@188b4850c0f2f5565a6310810c936ea960e2210f \
    --with github.com/caddy-dns/cloudflare@master \
    --with github.com/caddyserver/certmagic@master \
    --with github.com/caddyserver/caddy@master \
    --with github.com/mholt/caddy-webdav \
    --with github.com/WeidiDeng/caddy-cloudflare-ip
    

FROM caddy:2.9.1

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
