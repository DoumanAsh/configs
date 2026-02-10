# dietpi

Configuration for minimal headless install

Following `dietpi.txt` customization bits are necessary:
- `AUTO_SETUP_SSH_PUBKEY` - add as many ssh keys as you need.
- `SOFTWARE_DISABLE_SSH_PASSWORD_LOGINS` - this config defaults to disable root password login, but ideally you want to disable all
- `AUTO_SETUP_GLOBAL_PASSWORD` - Setup default admin account password (used by both `root` and `dietpi`)

Configure `dietpi-wifi.txt` to enable Wi-Fi usage
