#!/bin/bash
set -x

IPATH=/usr/local/share/adsbaamt

systemctl disable --now adsbaamt-mlat
systemctl disable --now adsbaamt-mlat2 &>/dev/null
systemctl disable --now adsbaamt-feed

if [[ -d /usr/local/share/tar1090/html-adsbaamt ]]; then
    bash /usr/local/share/tar1090/uninstall.sh adsbaamt
fi

rm -f /lib/systemd/system/adsbaamt-mlat.service
rm -f /lib/systemd/system/adsbaamt-mlat2.service
rm -f /lib/systemd/system/adsbaamt-feed.service

cp -f "$IPATH/adsbaamt-uuid" /tmp/adsbaamt-uuid
rm -rf "$IPATH"
mkdir -p "$IPATH"
mv -f /tmp/adsbaamt-uuid "$IPATH/adsbaamt-uuid"

set +x

echo -----
echo "adsb.fi feed scripts have been uninstalled!"
