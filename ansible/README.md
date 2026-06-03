# ansible setup

Personal setup for ansible to deploy configs within this repo

## Playbooks

- [check](./playbook/check.yaml) - Verifies connectivity and machine parameters
- [fluent-bit](./playbook/fluent-bit.yaml) - Deploys fluent-bit configs. Requires to create `opennobserve.yaml` in [vars](./vars) folder with `opennobserve.token` containing token
