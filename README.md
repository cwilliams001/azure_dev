# Azure VM Deployment with Terraform

This repository contains Terraform configurations to deploy virtual machines in Azure. Before you begin, ensure you have the necessary prerequisites installed and configured.

## Prerequisites

1. **Azure CLI**:
    - Install the Azure CLI by following the instructions on the [official website](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
    - Once installed, open a terminal and run the following command to login to your Azure account:
      ```bash
      az login
      ```
      Follow the prompts to complete the login process.

2. **SSH Keypair**:
    - You will need an SSH keypair to securely access the deployed VMs.
    - If you do not have an SSH keypair, you can generate one by running the following command in your terminal:
      ```bash
      ssh-keygen -t rsa -b 4096 -f ~/.ssh/dev-azure
      ```

## Understanding the Terraform Configuration

The main Terraform configuration file is `main.tf`. Here's a breakdown of its key components:

- **Provider Configuration**: This block configures the Azure provider for Terraform.
- **Resource Group**: A resource group is created to organize all the resources.
- **Virtual Network and Subnet**: These resources create a virtual network and subnet where the VMs will reside.
- **Network Security Group and Rules**: These resources set up a network security group with a basic rule to control traffic to the VMs.
- **Public IP**: A unique public IP address is provisioned for each VM.
- **Network Interface**: A network interface is created for each VM, associating it with the subnet, network security group, and public IP address.
- **Virtual Machine**: The VMs are created using this block, with each VM having its own network interface, and SSH key for secure access.

### Adjusting VM Count

- The `vm_count` value in the `locals` block controls how many VMs will be created. Adjust this value to create more or fewer VMs.

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
