# ansible setup

Personal setup for ansible to deploy configs within this repo

## Inventory

- [vps](./inventory/vps.yaml) - Hostname with my VPS. Expected to be simple Alpine distro

## Playbooks

- VPS only
    - Requires to setup token for OTEL defined as `opennobserve.token`
    - [check](./playbook/check.yaml) - Verifies connectivity and machine parameters
    - [fluent-bit](./playbook/fluent-bit.yaml) - Deploys fluent-bit configs. Requires to create `opennobserve.yaml` in [vars](./vars) folder with `opennobserve.token` containing token
    - [vector](./playbook/vector.yaml) - Deploys vector onto `vps` installing it as service using [vector](../vector/vps) setup
    - [ssh](./playbook/ssh.yaml) - Deploys dropbear ssh config
    - [tcpbin](./playbook/tcpbin.yaml) - Deploys [tcpbin](https://github.com/DoumanAsh/tcpbin) as initd service
    - [rustical](./playbook/rustical.yaml) - Deploys [rustical](https://github.com/lennart-k/rustical) as initd service using [config](../rustical/)
