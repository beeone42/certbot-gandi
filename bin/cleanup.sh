#!/bin/sh

api='https://api.gandi.net/v5/livedns'

domain=$(echo "$CERTBOT_DOMAIN" | sed -r 's/.+\.(.+\..+)/\1/')
subdomain=$(echo "$CERTBOT_DOMAIN" | sed -r 's/(.+)\..+\..+/\1/')

cache=/tmp/gandi-cache

if [ $subdomain == $domain ]; then
  record_name="_acme-challenge"
else
  record_name="_acme-challenge.$subdomain"
fi

#echo "apikey: $GANDI_API_KEY"
#echo "domain: $CERTBOT_DOMAIN"
#echo "record: $record_name"
#echo "valide: $CERTBOT_VALIDATION"

# if cache is already removed, record is already cleaned up so we can exit here

if [[ ! -f "$cache"-"$record_name" ]] ; then
    exit
fi

rm -f "$cache"-"$record_name"

curl -s -X DELETE \
    -H 'Content-Type: application/json' \
    -H "authorization: Bearer $GANDI_API_KEY" \
    "$api/domains/$domain/records/$record_name/TXT" >&2
