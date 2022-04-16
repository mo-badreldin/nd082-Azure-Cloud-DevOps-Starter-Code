# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction

For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started

1. Clone this repository

2. Create and assign custom policies using Azure CLI

3. Create custom image using Packer

4. Create infrastucture using Terraform

### Dependencies

1. Create an [Azure Account](https://portal.azure.com)
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions

1. Create a custom policy definition

```
    az policy definition create --name "name" --rules "<path to .json file>"
```
2. Create a custom policy assignment

```
    az policy assignment create --name "name" --scope "subscription_id" --policy "<policy id>"
```
3. Use Azure CLI to create a Service Principal 

```
    az ad sp create-for-rbac --role="Contributor" --scopes="subscription_id"
```
4. Set environment variables **"TF_VAR_subscription_id"** , **"TF_VAR_client_id"**, **"TF_VAR_client_secret"** and **"TF_VAR_tenant_id"**

5. Use Packer to create the image

```
    packer build server.json
```
6. Use Terraform to create the infrastucture

```
    terraform init
    terraform plan --out solution.plan -var 'variable=varaible_value'
    terraform apply solution.plan 
```
7. Required variables are defined in variables.tf. Default values can be added to the file or value could be passed through cmdline when running terraform plan
    * prefix: The prefix for all resources in the template
    * location: The Azure Region in which all resources in this example should be created.
    * username: The username of the account of the VM(s)
    * source_image_id: The ID of the source image for the VM(s)
    * vm_machine_count: The number of virtual machines to deploy


### Output
The number of deployed resources is based on value of vm_machine_count. For a vm_machine_count=3, a total number of 21 resources should be deployed.

