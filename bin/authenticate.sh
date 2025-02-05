#!/bin/sh

api='https://api.gandi.net/v5/livedns'

domain=$(echo "$CERTBOT_DOMAIN" | sed -r 's/.+\.(.+\..+)/\1/')
subdomain=$(echo "$CERTBOT_DOMAIN" | sed -r 's/(.+)\..+\..+/\1/')

cache=/tmp/gandi-cache


if [ -z "${CERTBOT_WAIT}" ]; then 
    wait='30'
else 
    wait=${CERTBOT_WAIT}
fi

if [ $subdomain == $domain ]; then
  record_name="_acme-challenge"
else
  record_name="_acme-challenge.$subdomain"
fi

echo \"$CERTBOT_VALIDATION\" >> "$cache"-"$record_name"

value=`cat "$cache"-"$record_name" | tr '\n' ',' | sed 's/,$/\n/'`

#echo "apikey: $GANDI_API_KEY"
echo "domain: $domain"
echo "record: $record_name"
echo "valide: $CERTBOT_VALIDATION"
echo "value : $value"

curl -s -X PUT \
    -H 'Content-Type: application/json' \
    -H "authorization: Bearer $GANDI_API_KEY" \
    -d "{\"rrset_ttl\": 300,
         \"rrset_values\": [$value]}" \
    "$api/domains/$domain/records/$record_name/TXT" | sed 's/{"message":"DNS Record Created"}//' >&2

echo "wait $wait s for propagation..."
sleep $wait
echo "done"
