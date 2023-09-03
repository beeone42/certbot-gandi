#!/bin/sh

certbot certonly --manual \
        --expand \
        --agree-tos \
        --no-eff-email \
        --non-interactive \
        --preferred-challenges=dns \
        --manual-auth-hook authenticate.sh \
        --manual-cleanup-hook cleanup.sh \
        "$@"
