#!/bin/sh
# install let's encrypt certs with cloudflare ACME resolver plugin
# https://go-acme.github.io/lego/dns/cloudflare/
GOACME_DL="https://github.com/go-acme/lego/releases/download/v4.13.3/lego_v4.13.3_linux_386.tar.gz"

# In cloudflare, create an API key scoped to your domain with the following
# permissions. The resulting key is specified in CLOUDFLARE_ZONE_API_TOKEN
# Zone / Zone / Read
# Zone / DNS / Edit

# check cf bw
#export CLOUDFLARE_DNS_API_TOKEN="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#export LETSENCRYPT_EMAIL="xxxxxxxxxxxxxxx"
#export DOMAINS="*.xxxxxxxxxxxxxx"

if [ -z "$CLOUDLARE_DNS_API_TOKEN" ];
  echo "[-] specify the environment variables first"
  exit 1
fi

set -xe
TMP=$(mktemp --directory)
WD="$(pwd)"

die() {
  if [ -d "$TMP" ]; then
    cd "$WD"
    echo "[+] cleaning up $TMP"
    rm -rf "$TMP"
  fi
}
trap die EXIT


echo "[+] installing lego"
cd $TMP
curl -L --output lego.tar.gz $GOACME_DL
tar -xvzf lego.tar.gz
chmod +x lego
cp lego /usr/local/bin/
which lego

cd
echo "[+] issuing certs"
/usr/local/bin/lego --dns.resolver 1.1.1.1 --accept-tos --email $LETSENCRYPT_EMAIL --dns cloudflare --domains $DOMAINS run

CRONJOB="3 3 * * * /usr/local/bin/lego --dns.resolver 1.1.1.1 --accept-tos --email $LETSENCRYPT_EMAIL --dns cloudflare --domains $DOMAINS renew"
if crontab -l | grep -q "$DOMAINS renew"; then
  echo "[>] already have a cronjob, skipping crontab install."
else
  echo "[+] setting up cert renew crontab"
  crontab -l | { cat; echo "$CRONJOB"; } | crontab -
fi

cat << EOF
=======================================================================

certs are found in: $WD/.lego/certificates/

pubkey: $DOMAINS.crt
privkey: $DOMAINS.key

=======================================================================
EOF
exit 0
