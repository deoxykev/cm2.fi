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

set -xe
TMP=$(mktemp --directory)
WD="$(pwd)"

die() {
  if [ -f $TMP/resolv.conf.bak ]; then
    echo "[+] restoring /etc/resolv.conf"
    cp $TMP/resolv.conf.bak /etc/resolv.conf
  fi

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

# this is a workaround because of split DNS
echo "[+] modifying resolver temporarily"
cp /etc/resolv.conf $TMP/resolv.conf.bak
echo "nameserver 1.1.1.1" > /etc/resolv.conf

cd
echo "[+] issuing certs"
/usr/local/bin/lego --accept-tos --email $LETSENCRYPT_EMAIL --dns cloudflare --domains $DOMAINS run

CRONJOB="3 3 * * * /usr/local/bin/lego --accept-tos --email $LETSENCRYPT_EMAIL --dns cloudflare --domains $DOMAINS renew"
if crontab -l | grep -q "$DOMAINS renew"; then
  echo "[>] already have a cronjob, skipping crontab install."
else
  echo "[+] setting up cert renew crontab"
  crontab -l | { cat; echo "$CRONJOB"; } | crontab -
fi

exit 0
