# fusionauth-example-terraform-deploy-fusionauth

This example documents how to deploy FusionAuth and its database using Terraform.

## Features

This code illustrates how to:

1. Use the Docker Terraform Provider
2. Create a FusionAuth container and its database container

## Prerequisite

1.  Install the Terraform CLI, https://developer.hashicorp.com/terraform/tutorials/docker-get-started/install-cli
2.  Install OrbStack or Docker Desktop

## Setup

- Initialize the directory
    ```
    terraform init
    ```
- Create the infrastructure
    ```
    terraform apply
    ```
    
## Useful commands

- Format and validate configuration changes
    ```
    terraform fmt
    ```
    ```
    terraform validate
    ```
- Inspect state
    ```
    terraform show
    ```
- List the resources in the project state
    ```
    terraform state list
    ```
