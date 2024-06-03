#!/bin/bash
set -x

IPATH=/usr/local/share/adsb-aamt

systemctl disable --now adsb-aamt-mlat
systemctl disable --now adsb-aamt-mlat2 &>/dev/null
systemctl disable --now adsb-aamt-feed

if [[ -d /usr/local/share/tar1090/html-adsbfi ]]; then
    bash /usr/local/share/tar1090/uninstall.sh adsbfi
fi

rm -f /lib/systemd/system/adsb-aamt-mlat.service
rm -f /lib/systemd/system/adsb-aamt-mlat2.service
rm -f /lib/systemd/system/adsb-aamt-feed.service

cp -f "$IPATH/adsb-aamt-uuid" /tmp/adsb-aamt-uuid
rm -rf "$IPATH"
mkdir -p "$IPATH"
mv -f /tmp/adsbfi-uuid "$IPATH/adsb-aamt-uuid"

set +x

echo -----
echo "adsb.fi feed scripts have been uninstalled!"
