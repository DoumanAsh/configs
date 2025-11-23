# rustical

## InitRC

[rustical.initd](./rustical.initd) can be placed in `/etc/init.d` to be used as service:

```
sudo cp ./rustical.initd /etc/init.d/rustical
sudo chmod +x /etc/init.d/rustical
sudo rc-update add rustical default
sudo rc-service rustical start
```

## Build instruction

- Disable openssl's vendored feature
- Install `openssl-dev`
- Apply [rustical.patch](./rustical.patch)
- Perform build `OPENSSL_NO_VENDOR=1 cargo build --release`
    - Alpine specific command to try to fix dynamic openssl linkage `RUSTFLAGS="-C target-feature=-crt-static" OPENSSL_NO_VENDOR=1 TARGET=x86_64-unknown-linux-musl cargo build --release`
- Install `sudo cp target/release/rustical /usr/bin/rustical`
- Modify group `sudo chgrp www-data /usr/bin/rustical`

## Setup

- Create system user: `sudo adduser -D -k /etc/rustical -h /var/lib/rustical -G www-data rustical`
- Create user account (run under sufficient privileges): `rustical principals create -p individual -n $DISPLAY_NAME --pasword $USER_ACCOUNT_PASSWORD`
