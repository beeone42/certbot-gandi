letsencrypt-gandi
========================

This container generates [LetsEncrypt](https://www.letsencrypt.org) certificates for subdomains at [Gandi](https://www.gandi.net) using the DNS-01 challenge type and Gandi's new LiveDNS API.

This image is based on Alpine and uses [Certbot](https://certbot.eff.org/) to communicate with Letsencrypt.

Build
--------

You can find build of this image here: [https://github.com/beeone42/docker-letsencrypt-gandi](https://hub.docker.com/r/beeone/letsencrypt-gandi)

Running
-------------

The container can then be started to create a wildcard certificate as follows:

        docker run --rm \
                -v /path/to/certs:/etc/letsencrypt \
                -e GANDI_API_KEY=<your-gandi-personal-access-token> \
                beeone/letsencrypt-gandi:latest \
                  --email <your@email.org> \
                  --server https://acme-v02.api.letsencrypt.org/directory \
                  -d \*.<your-domain.org> -d <your-domain.org>

The container will then generate a certificate. The certificate will be available in `path/to/certs/live/`, in a directory named after the first domain specified in the config file.

To test / debug, use this option: 

    --server  https://acme-staging-v02.api.letsencrypt.org/directory
