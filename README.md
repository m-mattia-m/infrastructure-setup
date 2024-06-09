# Private infrastructure

## Clone this repository

1. Setup new linux node
2. log in into the node
3. create folder `mkdir ìnfrastructure && cd infrastructure` -> pwd: /home/<your-username>/infrastructure
4. run `git clone https://<pat>@github.com/m-mattia-m/infrastructure-setup.git`
5. install make: `sudo apt install make`

## Setup infrastructure

1. edit the `config.env`-File
2. run `sudo make startup`

## Notes

- The Caddy need 1-3 minutes to generate certificates -> https://domain.tld/health
- The DNS-Record can't be proxied for successfull verification -> e.g. don't active cloudflare DNS-Record-Proxy
- DNS-Record: CNAME service -> dynDNS/Host proxy=false
