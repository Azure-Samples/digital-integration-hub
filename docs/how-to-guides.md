# How To Guides

As you get more familiar with the code base, we want you to feel empowered to customize and run the template however you wish. This section provides guides for common tasks and troubleshooting.

## Table of Contents

- [How To Guides](#how-to-guides)
  - [Table of Contents](#table-of-contents)
  - [Use VS Code development container](#use-vs-code-development-container)
  - [Use local VS Code with GitHub Codespaces](#use-local-vs-code-with-github-codespaces)
  - [Clean and Rebuild your dev environment](#clean-and-rebuild-your-dev-environment)
  - [Troubleshooting issues when deploying to Azure](#troubleshooting-issues-when-deploying-to-azure)
  - [Deploy to a specific region](#deploy-to-a-specific-region)
  - [Create multiple environments](#create-multiple-environments)
  - [Change names of resources of the resource group](#change-names-of-resources-of-the-resource-group)
  - [Add a new service](#add-a-new-service)
  - [Troubleshoot Codespaces](#troubleshoot-codespaces)

## Use VS Code development container

If you do not have access to GitHub Codespaces or would like to use VS Code to develop inside a container, take a look at [this article](https://code.visualstudio.com/docs/remote/containers).

## Use local VS Code with GitHub Codespaces

If you would like to use VS Code locally and connect to GitHub Codespaces, follow these steps outlined in this article: [Using Codespaces in VS Code](https://docs.github.com/github/developing-online-with-codespaces/using-codespaces-in-visual-studio-code).

## Clean and Rebuild your dev environment

The [`.devcontainer folder`](../.devcontainer/) contains all of the development environment configuration to run the application in Codespaces or a dev container. When changes are made to **any file** in this folder, you must open the Command Palette (`Ctrl + Shift + P`  or `CMD + Shift + P`) and run **Remote-Containers: Rebuild Container** or **Remote-Containers: Rebuild and Reopen in Container** depending on if you are in a dev container or not.

## Troubleshooting issues when deploying to Azure

Look at this article for troubleshooting a wide range of [common deployment errors](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/common-deployment-errors), when deploying to Azure.

## Deploy to a specific region

The template deploys to the region specified in the `AZURE_LOCATION` attribute in the [environments.yaml](../environments/environments.yaml) file.

Please note that changing the region will not delete any existing deployments.

## Create multiple environments

To create multiple environments of the application, you can either extend the existing workflow, or duplicate the workflow. GitHub provides guidance on how to [manage complex workflows](https://docs.github.com/en/actions/learn-github-actions/managing-complex-workflows).
## Change names of resources of the resource group

As part of this template, resource names are [generated automatically](/docs/concepts.md#resource-naming).

You can change the `RESOURCE_NAME_PREFIX` attribute in the [environments.yaml](../environments/environments.yaml) file to influence the generated resource group and resource names.

## Add a new service

To add an additional service to this template, you need to ensure the following:

1. Add the required Bicep definition for the Azure resource to host the service in the [infra folder](../src/arm/).
1. Add a reference to the module in the [main.bicep file](../src/arm/main.bicep). To learn more about Bicep [take a look here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/bicep-overview).
1. Add the service code.
1. To build your service as part of the [build-release workflow](../.github/workflows/build_release.yaml), add the required build job at the beginning of the workflow.
1. For any additional actions required as part of deploying the service, you can add the required steps to the [install.sh script](../deploy/scripts/install.sh).

For more information about the build and release setup in the template, look [here](/docs/concepts.md#build-and-deployment).

## Troubleshoot Codespaces

If you encounter any issues with Codespaces, this document provides a list of [common questions when using Codespaces](https://code.visualstudio.com/docs/remote/codespaces#_common-questions)

Note that if you have [user settings synchronization](https://code.visualstudio.com/docs/editor/settings-sync) turned on in VS Code, these are also applied when opening VS Code in the browser in Codespaces.