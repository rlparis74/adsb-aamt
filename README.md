# adsb.fi feed client

- These scripts aid in setting up your current ADS-B receiver to feed [adsb.fi](https://adsb.fi/).
- This will not disrupt any existing feed clients already present.
- When setting up new feeders, a decoder such as [readsb](https://github.com/adsbaamt/adsb-scripts/wiki/Automatic-installation-for-readsb) must be installed separately.

## 1: Find antenna coordinates and elevation

<https://www.freemaptools.com/elevation-finder.htm>

## 2: Install the feed client

```
curl -L -o /tmp/feed.sh https://adsb.fi/feed.sh
sudo bash /tmp/feed.sh
```

## 3: Use netstat to check that your feed is working

```
netstat -t -n | grep -E '30004|31090'
```
Expected Output:
```
tcp        0    182 localhost:43530     65.109.2.208:31090      ESTABLISHED
tcp        0    410 localhost:47332     65.109.2.208:30004      ESTABLISHED
```

## 4: Optional: Install [local interface](https://github.com/wiedehopf/tar1090) for your data

The interface will be available at http://192.168.X.XX/adsbaamt  
Replace the IP address with the address of your Raspberry Pi.

Install / Update:
```
sudo bash /usr/local/share/adsbaamt/git/install-or-update-interface.sh
```
Remove:
```
sudo bash /usr/local/share/tar1090/uninstall.sh adsbaamt
```

### Update the feed client without reconfiguring

```
curl -L -o /tmp/update.sh https://raw.githubusercontent.com/adsbaamt/adsb-fi-scripts/master/update.sh
sudo bash /tmp/update.sh
```

### If you encounter issues, please do a reboot and then supply these logs on Discord (last 20 lines for each is sufficient):

```
sudo journalctl -u adsbaamt-feed --no-pager
sudo journalctl -u adsbaamt-mlat --no-pager
```

### Display the configuration

```
cat /etc/default/adsbaamt
```

### Use an external source

If your feeder is on a separate device from the one this script is installed.
Edit config `sudo nano /etc/default/adsbaamt` and change the IP on the following lines to point to your feeder device's IP:

```
INPUT="127.0.0.1:30005"
...
UAT_INPUT="127.0.0.1:30978"
```
Then restart the feed client:
```
sudo systemctl restart adsbaamt-feed
sudo systemctl restart adsbaamt-mlat
```

### Changing the configuration

This is the same as the initial installation.
If the client is up to date it should not take as long as the original installation,
otherwise this will also update the client which will take a moment.

```
curl -L -o /tmp/feed.sh https://raw.githubusercontent.com/adsbaamt/adsb-fi-scripts/master/install.sh
sudo bash /tmp/feed.sh
```
Alternatively edit the config directly and restart the feed client
```
sudo nano /etc/default/adsbaamt
sudo systemctl restart adsbaamt-feed
sudo systemctl restart adsbaamt-mlat
```

### Disable / Enable adsb.fi MLAT-results in your main decoder interface (readsb / dump1090-fa)

This is enabled by default. You probably don't need to change that.

- Disable:

```
sudo sed --follow-symlinks -i -e 's/RESULTS=.*/RESULTS=""/' /etc/default/adsbaamt
sudo systemctl restart adsbaamt-mlat
```
- Enable:

```
sudo sed --follow-symlinks -i -e 's/RESULTS=.*/RESULTS="--results beast,connect,127.0.0.1:30104"/' /etc/default/adsbaamt
sudo systemctl restart adsbaamt-mlat
```

### Restart the feed client

```
sudo systemctl restart adsbaamt-feed
sudo systemctl restart adsbaamt-mlat
```

### Show status

```
sudo systemctl status adsbaamt-feed
sudo systemctl status adsbaamt-mlat
```

### Removal / disabling the services

```
sudo bash /usr/local/share/adsbaamt/uninstall.sh
```

If the above doesn't work, you can just disable the services and the scripts won't run anymore:

```
sudo systemctl disable --now adsbaamt-feed
sudo systemctl disable --now adsbaamt-mlat
```
