# `caddy`

→ [lucaslorentz/caddy-docker-proxy](https://github.com/lucaslorentz/caddy-docker-proxy)

## Setup

```bash
docker network create caddy
```

## Running 

```bash
docker-compose up -d
```

## Check Logs

to check if caddyfiles have issues or certificated cannot be obtained

```bash
docker logs caddy -f
```

## Development Certificates

To generate a local certificate for development: 

```yaml
# docker-compose.yml

services:
  app:
    # ...
    labels:
      caddy: "https://app.lo"
      caddy.tls: "internal"
    # ...
```

The root certificate is stored in [local-certs/](local-certs/).

Install the `root.crt` in your trusted certificate store ([macOS](https://support.securly.com/hc/en-us/articles/206058318-How-to-install-the-Securly-SSL-certificate-on-Mac-OSX-) / [Windows](https://support.securly.com/hc/en-us/articles/360026808753-How-do-I-manually-install-the-Securly-SSL-certificate-on-Windows))

---

**Important:** Do not use any public TLDs, as they won't work in a local environment.

