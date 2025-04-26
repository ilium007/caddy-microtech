# Caddy Docker Custom Builds
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/ilium007/caddy-microtech?label=Release)](https://github.com/ilium007/caddy-microtech/releases)
[![License](https://img.shields.io/github/license/serfriz/caddy-custom-builds?label=License)](https://github.com/ilium007/caddy-microtech/blob/main/LICENSE)

[Caddy](https://github.com/caddyserver/caddy) takes a [modular approach](https://caddyserver.com/docs/extending-caddy) to building Docker images, allowing users to include only the [modules](https://caddyserver.com/docs/modules/) they need. This repository aims to provide flexibility and convenience to run Caddy with specific combinations of modules by providing pre-built images according to the needs and preferences of the users.

All custom images are updated automatically when a [new version](https://github.com/caddyserver/caddy/releases) of Caddy is released using the official [Caddy Docker](https://hub.docker.com/_/caddy) image. This is done by using GitHub Actions to build and push the images for all Caddy supported platforms to Docker Hub, GitHub Packages and Quay container registries. In addition, since the update cycle of many modules is faster than Caddy's, all custom images are periodically re-built with the latest version of their respective modules on the first day of every month. Those who are already running Caddy's latest version can force the update by re-creating the container (i.e. running `docker compose up --force-recreate` if using Docker Compose).

All commits and tags are signed with a GPG key to ensure their integrity and authenticity, and 2FA is enabled in the accounts involved in the management of this repository and the container registries.

## Builds

If you are looking for a specific custom build not available yet in this repository, please open a new [Issue](https://github.com/ilium007/caddy-microtech/issues) with your request. To make sure no broken or unsafe builds are created, the requested modules should be properly maintained and listed in the Caddy's [download page](https://caddyserver.com/download). Additional information and instructions can be found by clicking on the name of the Caddy images and modules listed below.

### Caddy Images:

- [**caddy-cloudflare**](https://github.com/ilium007/caddy-microtech/tree/master/caddy-cloudflare): includes Cloudflare DNS and IPs modules.
- [**caddy-webdav**](https://github.com/ilium007/caddy-microtech/tree/master/caddy-webdav): includes Cloudflare DNS and IPs modules.

### Modules:

- [**Cloudflare DNS**](https://github.com/ilium007/caddy-microtech?tab=readme-ov-file#dns-modules): for Cloudflare DNS-01 ACME validation support | [caddy-dns/cloudflare](https://github.com/caddy-dns/cloudflare)

## Usage

Since all images from this repository are built off the official Caddy Docker image, the same [volumes](https://docs.docker.com/storage/volumes/) and/or [bind mounts](https://docs.docker.com/storage/bind-mounts/), ports mapping, environment variables, etc. can be used with this container. Please refer to the official [Caddy Docker](https://hub.docker.com/_/caddy) image and [docs](https://caddyserver.com/docs/) for more information on using Caddy.

Docker builds for all Caddy supported platforms are available at the following container registries:
- **GitHub Packages** > `docker pull ghcr.io/ilium007/<caddy-build-name>:latest`

To pull a specific build, replace `<caddy-build-name>` with the desired one.

### Tags

The following tags are available for all images:

- `latest`
- `<version>` (eg: `2.7.4`, including: `2.7`, `2`, etc.)

### Container Creation

Simply create the container using the `docker run` command, or a `docker-compose.yml` file including the necessary [environment variables](https://caddyserver.com/docs/caddyfile/concepts#environment-variables) depending on the modules used. The following blocks contain examples for both methods using `<caddy-build-name>` as the image name (replace it with the desired Caddy build name), and including all environment variables required by the modules listed above (some may not apply to your specific build).

#### Docker Run

```sh
docker run --rm -it \
  --name caddy \  # feel free to choose your own container name
  --restart unless-stopped \  # run container unless stopped by user (optional)
  -p 80:80 \  # HTTP port
  -p 443:443 \  # HTTPS port
  -p 443:443/udp \  # HTTP/3 port (optional)
  -v caddy-data:/data \  # volume mount for certificates data
  -v caddy-config:/config \  # volume mount for configuration data
  -v $PWD/Caddyfile:/etc/caddy/Caddyfile \  # to use your own Caddyfile
  -v $PWD/log:/var/log \  # bind mount for the log directory (optional)
  -v $PWD/srv:/srv \  # bind mount to serve static sites or files (optional)
  -e CLOUDFLARE_API_TOKEN=<token-value> \  # Cloudflare API token (if applicable)
  -e DUCKDNS_API_TOKEN=<token-value> \  # DuckDNS API token (if applicable)
  -e CROWDSEC_API_KEY=<key-value> \  # CrowdSec API key (if applicable)
  -e GANDI_BEARER_TOKEN=<token-value> \  # Gandi API token (if applicable)
  -e NETCUP_CUSTOMER_NUMBER=<number-value> \  # Netcup customer number (if applicable)
  -e NETCUP_API_KEY=<key-value> \  # Netcup API key (if applicable)
  -e NETCUP_API_PASSWORD=<password-value> \  # Netcup API password (if applicable)
  -e PORKBUN_API_KEY=<key-value> \  # Porkbun API key (if applicable)
  -e PORKBUN_API_SECRET_KEY=<secret-key-value> \  # Porkbun API secret key (if applicable)
  -e OVH_ENDPOINT=<endpoint-value> \  # OVH endpoint (if applicable)
  -e OVH_APPLICATION_KEY=<application-value> \  # OVH application key (if applicable)
  -e OVH_APPLICATION_SECRET=<secret-value> \  # OVH application secret (if applicable)
  -e OVH_CONSUMER_KEY=<consumer-key-value> \  # OVH consumer key (if applicable)
  ilium007/<caddy-build-name>:latest  # replace with the desired Caddy build name
```

The volume and bind mounts can be adjusted to meet to your needs, `$PWD` is used to reference the current working directory, but you can replace it with your preferred path. The environment variables are only required if the modules used in the build require them.

The default [Caddyfile](https://github.com/caddyserver/dist/blob/master/config/Caddyfile) that is included inside the Docker container is just a placeholder to serve a static Caddy welcome page with some useful instructions. So you will most likely want to mount your own `$PWD/Caddyfile` to configure Caddy according to your needs (the file must already exist in the specified path before creating the container).

The [restart policy](https://docs.docker.com/config/containers/start-containers-automatically/#use-a-restart-policy) can be adjusted to your needs. The policy `unless-stopped` ensures the container is always running (even at boot) unless it is explicitly stopped by the user.

#### Docker Compose

```yaml
version: "3.7"
services:
  caddy:
    image: ilium007/<caddy-build-name>:latest  # replace with the desired Caddy build name
    container_name: caddy  # feel free to choose your own container name
    restart: "unless-stopped"  # run container unless stopped by user (optional) 
    ports:
      - "80:80"  # HTTP port
      - "443:443"  # HTTPS port
      - "443:443/udp"  # HTTP/3 port (optional)
    volumes:
      - caddy-data:/data  # volume mount for certificates data
      - caddy-config:/config  # volume mount for configuration data
      - $PWD/Caddyfile:/etc/caddy/Caddyfile  # to use your own Caddyfile
      - $PWD/log:/var/log  # bind mount for the log directory (optional)
      - $PWD/srv:/srv  # bind mount to serve static sites or files (optional)
    environment:
      - CLOUDFLARE_API_TOKEN=<token-value>  # Cloudflare API token (if applicable)
      - DUCKDNS_API_TOKEN=<token-value>  # DuckDNS API token (if applicable)
      - CROWDSEC_API_KEY=<key-value>  # CrowdSec API key (if applicable)
      - GANDI_BEARER_TOKEN=<token-value>  # Gandi API token (if applicable)
      - NETCUP_CUSTOMER_NUMBER=<number-value>  # Netcup customer number (if applicable)
      - NETCUP_API_KEY=<key-value>  # Netcup API key (if applicable)
      - NETCUP_API_PASSWORD=<password-value>  # Netcup API password (if applicable)
      - PORKBUN_API_KEY=<key-value>  # Porkbun API key (if applicable)
      - PORKBUN_API_SECRET_KEY=<secret-key-value>  # Porkbun API secret key (if applicable)
      - OVH_ENDPOINT=<endpoint-value>  # OVH endpoint (if applicable)
      - OVH_APPLICATION_KEY=<application-value>  # OVH application key (if applicable)
      - OVH_APPLICATION_SECRET=<secret-value>  # OVH application secret (if applicable)
      - OVH_CONSUMER_KEY=<consumer-key-value>  # OVH consumer key (if applicable)
volumes:
  caddy-data:
    external: true
  caddy-config:
```

Defining the data volume as [external](https://docs.docker.com/compose/compose-file/compose-file-v3/#external) ensures that `docker compose down` does not delete the volume, but you may need to create it first using `docker volume create caddy-data`. This doesn't apply to bind mounts if you opt to use them instead of volumes.

### Graceful Reloads

Caddy does not require a full restart when the `Caddyfile` is modified. Caddy comes with a [caddy reload](https://caddyserver.com/docs/command-line#caddy-reload) command which can be used to reload its configuration with zero downtime.

When running Caddy in Docker, the recommended way to trigger a config reload is by executing the `caddy reload` command in the running container. First, you'll need to determine your container ID or name. Then, pass the container ID to docker exec. The working directory is set to /etc/caddy so Caddy can find your `Caddyfile` without additional arguments.

```sh
caddy_container_id=$(docker ps | grep caddy | awk '{print $1;}')  # use your container name if different from 'caddy'
docker exec -w /etc/caddy $caddy_container_id caddy reload
```

It is possible to create an [alias](https://phoenixnap.com/kb/linux-alias-command) for the `caddy reload` command to make it more convenient to use by adding the following line to your `~/.bashrc` or `~/.zshrc` file:
    
```sh
alias caddy-reload="docker exec -w /etc/caddy $(docker ps | grep caddy | awk '{print $1;}') caddy reload"
```

Once you have added the alias to the appropriate file, you will need to source it for the changes to take effect. You can do this by running `source ~/.bashrc` or `source ~/.zshrc` in your terminal. After this, you will be able to use the `caddy-reload` alias in your terminal sessions.

## Configuration

This section aims to provide some basic information on how to configure Caddy with the modules included in the custom builds, but it is not intended to be a comprehensive guide. All the examples are based on the official [Caddyfile](https://caddyserver.com/docs/caddyfile) syntax and the modules' documentation.

### DNS Modules

To make use of the different modules that provide DNS-01 ACME validation support at the server level, set the global [acme_dns](https://caddyserver.com/docs/caddyfile/options#acme-dns) directive in your `Caddyfile` using your DNS provider's name and the respective environment variable for the API token. The example shows the use case for Cloudflare DNS with the rest of the DNS providers commented out.

```Caddyfile
{
  acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN} #  for Cloudflare
  # acme_dns duckdns {env.DUCKDNS_API_TOKEN} #  for DuckDNS
  # acme_dns gandi {env.GANDI_BEARER_TOKEN} #  for Gandi
  # acme_dns netcup {  # for Netcup
  #   customer_number {env.NETCUP_CUSTOMER_NUMBER}
  #   api_key {env.NETCUP_API_KEY}
  #   api_password {env.NETCUP_API_PASSWORD}
  # }
  # acme_dns porkbun {  # for Porkbun
  #   api_key {env.PORKBUN_API_KEY}
  #   api_secret_key {env.PORKBUN_API_SECRET_KEY}
  # }
  # acme_dns ovh {  # for OVH
  #   endpoint {env.OVH_ENDPOINT}
  #   application_key {env.OVH_APPLICATION_KEY}
  #   application_secret {env.OVH_APPLICATION_SECRET}
  #   consumer_key {env.OVH_CONSUMER_KEY}
  # }
  # Please refer to the respective Caddy DNS plugin page for other DNS providers
}
```

Alternatively, you can use the [`tls`](https://caddyserver.com/docs/caddyfile/directives/tls#tls) directive at each site. See the [caddy-dns/cloudflare](https://github.com/caddy-dns/cloudflare) module for additional details.

```Caddyfile
my.domain.tld {
  tls {
    dns cloudflare {env.CLOUDFLARE_API_TOKEN}  # for Cloudflare
    # dns duckdns {env.DUCKDNS_API_TOKEN}  # for DuckDNS
    # dns gandi {env.GANDI_BEARER_TOKEN}  # for Gandi
    # dns netcup {  # for Netcup
    #   customer_number {env.NETCUP_CUSTOMER_NUMBER}
    #   api_key {env.NETCUP_API_KEY}
    #   api_password {env.NETCUP_API_PASSWORD}
    # }
    # dns porkbun {  # for Porkbun
    #   api_key {env.PORKBUN_API_KEY}
    #   api_secret_key {env.PORKBUN_API_SECRET_KEY}
    # }
    # dns ovh {  # for OVH
    #   endpoint {env.OVH_ENDPOINT}
    #   application_key {env.OVH_APPLICATION_KEY}
    #   application_secret {env.OVH_APPLICATION_SECRET}
    #   consumer_key {env.OVH_CONSUMER_KEY}
    # }
    # Please refer to the respective Caddy DNS plugin page for other DNS providers
  }
}
```

#### Creating a Cloudflare API Token

You can generate a Cloudflare API token via the Cloudflare web dashboard through the following steps:

1. Login to your Cloudflare [Dashboard](https://dash.cloudflare.com/)
2. Go to [Account Profile](https://dash.cloudflare.com/profile) > [API Tokens](https://dash.cloudflare.com/profile/api-tokens)
3. Click "Create token" (Use the "Create Custom Token" option)
4. Grant the following permissions:
   - `Zone > Zone > Read`
   - `Zone > DNS > Edit`
5. Copy the token and use it as the `CLOUDFLARE_API_TOKEN` environment variable.

### Cloudflare IPs

To restrict access to your server only to Cloudflare's IP ranges, add the [trusted_proxies](https://caddyserver.com/docs/caddyfile/options#trusted-proxies) directive to the [global options](https://caddyserver.com/docs/caddyfile/options), under servers, in your `Caddyfile`. For additional details, refer to [trusted_proxies/cloudflare](https://caddyserver.com/docs/json/apps/http/servers/trusted_proxies/cloudflare/) documentation and [WeidiDeng/caddy-cloudflare-ip](https://github.com/WeidiDeng/caddy-cloudflare-ip) repository.

```Caddyfile
{
  servers {
    trusted_proxies cloudflare {
      interval 12h
      timeout 15s
    }
  }
}
```

### Dynamic DNS

To keep your DNS records updated with the public IP address of your instance, add the [dynamic_dns](https://caddyserver.com/docs/modules/dynamic_dns) directive to the [global options](https://caddyserver.com/docs/caddyfile/options) in your `Caddyfile`. This module regularly queries a service for your public IP address and updates the DNS records via your DNS provider's API whenever it changes. For additional details and advanced configuration examples refer to [mholt/caddy-dynamicdns](https://github.com/mholt/caddy-dynamicdns) repository. The example shows the use case for Cloudflare DNS with the rest of the DNS providers commented out.

```Caddyfile
{
  dynamic_dns {
    provider cloudflare {env.CLOUDFLARE_API_TOKEN}  # for Cloudflare
    # provider duckdns {env.DUCKDNS_API_TOKEN}  # for DuckDNS
    # provider gandi {env.GANDI_BEARER_TOKEN}  # for Gandi
    # provider netcup {  # for Netcup
    #   customer_number {env.NETCUP_CUSTOMER_NUMBER}
    #   api_key {env.NETCUP_API_KEY}
    #   api_password {env.NETCUP_API_PASSWORD}
    # }
    # provider porkbun {  # for Porkbun
    #   api_key {env.PORKBUN_API_KEY}
    #   api_secret_key {env.PORKBUN_API_SECRET_KEY}
    # }
    # provider ovh {  # for OVH
    #   endpoint {env.OVH_ENDPOINT}
    #   application_key {env.OVH_APPLICATION_KEY}
    #   application_secret {env.OVH_APPLICATION_SECRET}
    #   consumer_key {env.OVH_CONSUMER_KEY}
    # }
    # Please refer to the respective Caddy DNS plugin page for other DNS providers
    domains {
      domain.tld
    }
  }
}
```

Using the option [dynamic_domains](https://github.com/mholt/caddy-dynamicdns#dynamic-domains), it can also be configured to scan through the domains configured in the `Caddyfile` and try to manage those DNS records.

## Contributing

Feel free to contribute, request additional Caddy images with your preferred modules, and make things better by opening an [Issue](https://github.com/serfriz/caddy-custom-builds/issues) or [Pull Request](https://github.com/serfriz/caddy-custom-builds/pulls).

## License

Software under [GPL-3.0](https://github.com/serfriz/caddy-custom-builds/blob/main/LICENSE) ensures users' freedom to use, modify, and distribute it while keeping the source code accessible. It promotes transparency, collaboration, and knowledge sharing. Users agree to comply with the GPL-3.0 license terms and provide the same freedom to others.
