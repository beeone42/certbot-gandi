#!/bin/sh

api='https://api.gandi.net/v5/livedns'

domain=$(echo "$CERTBOT_DOMAIN" | sed -r 's/.+\.(.+\..+)/\1/')
subdomain=$(echo "$CERTBOT_DOMAIN" | sed -r 's/(.+)\..+\..+/\1/')

if [ $subdomain == $domain ]; then
  record_name="_acme-challenge"
else
  record_name="_acme-challenge.$subdomain"
fi

#echo "apikey: $GANDI_API_KEY"
echo "domain: $domain"
echo "record: $record_name"
echo "valide: $CERTBOT_VALIDATION"

curl -s -X PUT \
    -H 'Content-Type: application/json' \
    -H "authorization: Bearer $GANDI_API_KEY" \
    -d "{\"rrset_ttl\": 300,
         \"rrset_values\": [\"$CERTBOT_VALIDATION\"]}" \
    "$api/domains/$domain/records/$record_name/TXT" | sed 's/{"message":"DNS Record Created"}//' >&2
