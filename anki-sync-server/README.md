# anki-sync-server

## VPS

Alpine VPS setup is available [here](./vps/)

### InitRC

[anki-sync-server.initd](./vps/anki-sync-server.initd) can be placed in `/etc/init.d` to be used as service:

```
sudo mkdir /anki-sync
sudo cp ./vps/anki-sync-server.initd /etc/init.d/anki-sync-server
sudo chmod +x /etc/init.d/anki-sync-server
sudo rc-update add anki-sync-server default
sudo rc-service anki-sync-server start
```
