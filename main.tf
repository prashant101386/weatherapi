provider "azurerm" {
    version = "2.5.0"
    features {}
}

terraform {
    backend "azurerm" {
        resource_group_name = "tf_rg_blobstore"
        storage_account_name = "tfbackendstorage101386"
        container_name = "tfstate"
        key = "terraform.tfstate"
    }
}

variable "imagebuild" {
    type        = string
    description =  "Latest Image Build"
 }

resource "azurerm_resource_group" "rg" {
    name     = "Learning"
    location = "southindia"
}

resource "azurerm_container_group" "cg" {
    name                = "Learningcontainergroup"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_address_type     = "public"
    dns_name_label      = "weatherapitf101386"
    os_type             = "Linux"

    container {
        name            = "weatherapi"
        image           = "prashantjcd/weatherapi:${var.imagebuild}"
        cpu             = "1"
        memory          = "1"

        ports {
            port        = 80
            protocol    = "TCP"
        }
    }
}