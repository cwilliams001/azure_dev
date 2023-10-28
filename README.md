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

## Understanding the Ansible Playbook

The Ansible playbook `docker-wg.yml` sets up a WireGuard VPN server on the deployed VMs using Docker. Here's a breakdown of its key components:

- **Hosts**: Specifies the target host group where the playbook will be executed.
- **Variables**: Defines variables used in the playbook, loaded from `vars.yml`.
- **Tasks**:
  - Sets up directories for Docker volume mapping.
  - Installs Docker.
  - Pulls the WireGuard Docker image.
  - Runs the WireGuard container with specified environment variables and settings.
  - Fetches peer configuration files and QR code files to the local machine for distributing to VPN clients.

The `ansible.cfg` file contains configuration settings for Ansible, including the path to the inventory file, SSH key, and remote user.

The `vars.yml` file contains variables used in the playbook, such as the directory paths and the number of VPN peers.

## Deployment

### Terraform Deployment

Refer to the previous README section on Terraform deployment.

### Ansible Setup

1. Ensure the VMs are up and running and that you can SSH into them.
2. Update the `inventory.ini` file with the IP addresses of the VMs.
3. Run the following command to execute the Ansible playbook and set up WireGuard on the VMs:
   ```bash
   ansible-playbook docker-wg.yml
   ```

## Clean Up

To destroy the deployed resources, you can use the following command:

```bash
terraform destroy
```

