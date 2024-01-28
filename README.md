# Azure VM Deployment with Terraform and WireGuard Setup with Ansible

This repository contains Terraform configurations to deploy virtual machines in Azure and an Ansible playbook to set up a WireGuard VPN server on the VMs. Before you begin, ensure you have the necessary prerequisites installed and configured.

## Prerequisites

1. **Azure CLI**:
    - Install the Azure CLI by following the instructions on the [official website](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
    - Once installed, open a terminal and run the following command to login to your Azure account:
      ```bash
      az login
      ```
      Follow the prompts to complete the login process.

2. **SSH Keypair**:
    - You will need an SSH keypair to securely access the deployed VMs and for Ansible to communicate with the VMs.
    - If you do not have an SSH keypair, you can generate one by running the following command in your terminal:
      ```bash
      ssh-keygen -t rsa -b 4096 -f ~/.ssh/dev-azure
      ```

3. **Ansible**:
    - Install Ansible by following the instructions on the [official website](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).

## Understanding the Terraform Configuration

The main Terraform configuration file is `main.tf`. Here's a breakdown of its key components:

- **Provider Configuration**: This block configures the Azure provider for Terraform.
- **Modules**: The configuration is modularized into separate modules for network, VM, and DNS.
- **Variables**: Variables are declared and used to customize the deployment such as the number of VMs, SSH key path, domain name, and record prefix for DNS.
- **Resource Group**: A resource group is created to organize all the resources.
- **Virtual Network and Subnet**: These resources create a virtual network and subnet where the VMs will reside.
- **Network Security Group and Rules**: These resources set up a network security group with a basic rule to control traffic to the VMs.
- **Public IP**: A unique public IP address is provisioned for each VM.
- **Network Interface**: A network interface is created for each VM, associating it with the subnet, network security group, and public IP address.
- **Virtual Machine**: The VMs are created using this block, with each VM having its own network interface, and SSH key for secure access.

### Adjusting VM Count

- Adjustments like the number of VMs, SSH key, domain name, and record prefix can be made in the `terraform.tfvars` file.

### Source Image Reference

- The `source_image_reference` block within the VM resource specifies the image to be used for the VMs. The configuration is currently set to deploy Ubuntu Server 22.04 LTS.

## Deployment

1. Initialize Terraform:
   ```bash
   terraform init
   ```
2. Plan the deployment to see what resources will be created:
   ```bash
   terraform plan
   ```
3. Apply the configuration to deploy the resources:
   ```bash
   terraform apply
   ```

   To destroy the deployed resources, you can use the following command:

   ```bash
   terraform destroy
   ```

## Docker-WireGuard Setup with Ansible

The Ansible playbook `wg/docker-wg.yml` sets up a WireGuard VPN server on the deployed VMs using Docker. Here’s a breakdown of its key components:

### Directory Structure

```plaintext
.
├── ansible.cfg
└── wg
    ├── docker-wg.yml
    ├── scripts
    │   ├── update_mtu.sh
    │   └── update_peer_mtu.sh
    └── vars
        └── main.yml
```

### Variable Configuration

Update the necessary variables in the `wg/vars/main.yml` file before running the playbook. The variables include:

- `user_dir`: Directory on the VM for Docker volume mapping.
- `number_of_peers`: Number of peer configurations to create.
- `server_mtu_value`: MTU value for the server.
- `peer_mtu_value`: MTU value for the peers.
- `path_to_save_configs`: Local path to save the peer configurations and QR codes.

```yaml
user_dir: "/home/{{ ansible_env.USER }}/wireguard"
number_of_peers: 3
server_mtu_value: 1420
peer_mtu_value: 1420
path_to_save_configs: "/home/{{ lookup('env', 'USER') }}/Desktop"
```

### Playbook Execution

1. Ensure the VMs are up and running and that you can SSH into them.
2. The `templates/hosts.ini.tpl` file should create and update a `hosts.ini` file with the IP addresses of the VMs.
3. Navigate to the `wg` directory where the `docker-wg.yml` file is located.
4. Run the following command to execute the Ansible playbook and set up WireGuard on the VMs:

```bash
ansible-playbook wg/docker-wg.yml
```

The playbook performs various tasks including setting up directories for Docker volume mapping, installing Docker, pulling the WireGuard Docker image, running the WireGuard container with specified environment variables and settings, copying and executing scripts to update MTU values, and fetching peer configuration and QR code files to the local machine.

## Headscale Installation and Configuration with Ansible

### Directory Structure
   
   ```plaintext
   ├── headscale
│   ├── install_headscale.yml
│   └── vars
├── templates
│   ├── config_template.yaml
│   ├── hosts.ini.tpl
│   └── main.yml.tpl
  ```

Headscale is an open-source implementation of the Tailscale control server. The `install_headscale.yml` playbook automates the installation and configuration of Headscale on your VMs.

### Directory Structure

Under the `playbooks` directory, you will find the `headscale` directory which contains the `install_headscale.yml` playbook. The `templates` directory contains template files used by the playbook:

- `config_template.yaml`: Template for Headscale configuration.
- `hosts.ini.tpl`: Template for updating the hosts file.
- `main.yml.tpl`: Template for some main configurations.

### Playbook Breakdown

The `install_headscale.yml` playbook performs the following tasks:

1. **Include VM-specific variables**: Loads VM-specific variables from the `vars` directory.
2. **Download Headscale package**: Downloads the Headscale Debian package from GitHub.
3. **Install Headscale**: Installs the Headscale package using the `apt` module.
4. **Enable Headscale service**: Enables the Headscale service to start on boot.
5. **Create Backup Headscale configuration**: Creates a backup of the existing Headscale configuration file.
6. **Configure Headscale**: Applies configuration from `config_template.yaml`.
7. **Start Headscale**: Starts the Headscale service.

### Configuration Templates

The configuration templates use variable substitution to customize the configuration based on your environment these will be populated after the terraform apply command is executed.:

- `config_template.yaml`: Includes settings for server URL, listening address, and other Headscale configurations.
- `hosts.ini.tpl`: Used to update the hosts file with the IP addresses of your VMs.
- `main.yml.tpl`: Contains some main configurations like server URL, listening address, and others which are used by Headscale.

### Executing the Playbook

To execute the playbook, navigate to the `playbooks` directory and run the following command:

```bash
ansible-playbook headscale/install_headscale.yml
```

or

```bash
ansible-playbook wg/docker-wg.yml
```

## Clean Up

To destroy the deployed resources, you can use the following command frome the azure_dev directory:

```bash
terraform destroy
```