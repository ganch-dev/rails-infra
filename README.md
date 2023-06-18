# rails-infra

Infrastructure orchestration playbooks for new Rails apps that run in containers. This template uses https://guvnor.k.io/ for container management and zero-downtime app/service deployments.

## Requirements

- Python 3.7 or later with `pip`.
- Make

## Setup

1. Create an inventory file for your target server(s), similar to `inventories/hosts` file
```bash
[rails]
rails-01 ansible_host=127.0.0.1
```

2. Populate all required variables for the roles
3. Add and encrypt (with  `ansible-vault`) all secrets from `group_vars/all/vault.yml`
4. Add `git-crypt` to store your vault password before committing to the repository
5. Modify the guvnor application config in `roles/guvnor/templates/rails.yml`, read up the docs here: https://guvnor.k.io/service-configuration

## Quick Start

1. Install all Python and Ansible dependencies on your system run:
   ```
   make bootstrap
   ```
2. Check SSH connectivity to all machines:
   ```
   make ping INVENTORY=hosts ANSIBLE_USER=<existing-user-or-root>
   ```
3. Provision/deploy against all machines:
   ```
   make provision INVENTORY=hosts ANSIBLE_USER=<existing-user-or-root>
   ```

## Make Targets

### `bootstrap`

The `bootstrap` make target basically runs the following two commands to install
required Python packages and Ansible dependencies:

- `pip install -r requirements.txt`
- `ansible-galaxy install -f -r requirements.yml`

### `ping`

Checks connectivity too all machines that would be provisioned via the
`provision` target. Hence `ping` uses the same exact options as `provision`. It
effectively performs `ansible -m ping all`.

### `provision`

The `provision` make target runs ansible-playbook against the specified
inventory. It also passes in some extra command line flags which are most likely
needed. They are each configured with the following environment variables:

- `INVENTORY` — Used to specify the inventory name to use. Effectively adds
  `-i inventories/$INVENTORY` to the list of Ansible arguments.
- `ANSIBLE_USER` — The user Ansible will use to establish a SSH connection to
  the target machines. This overrides any `ansible_user` vars specified in
  inventory files directly. This is mostly needed for the `hosts` inventory
  where each person have their own unique username.
- `ASK_BECOME_PASS` — Passes the `--ask-become-pass` flag to the Ansible command to make Ansible
  prompt for the sudo password on the target machines.
- `TAGS` — When set to a non-empty string `--tag=$TAGS` will be added to the
  list of Ansible arguments.
- `ANSIBLE_ARGS` — Allows specifying additional arguments passed to
  `ansible-playbook`.
- `APT_UPGRADE` — Upgrade packages with `apt-get upgrade` when set to a
  non-empty string.
- `APT_DIST_UPGRADE` — Upgrade packages with `apt-get dist-upgrade` when set to
  a non-empty string.

### Post provisioning

On first run against a specific system, it is generally a good idea to upgrade
system packages.

- TODO: Guide on what's installed and how to use the newly provisioned host
