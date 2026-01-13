# Azure Notification Hubs Infrastructure Configuration
# This Terraform configuration creates a complete Azure Notification Hubs setup
# Including resource group, namespace, and notification hub with proper security


# Data source to get the current client configuration
resource "azurerm_client_config" "current" {}

# Resource Group
# Container for all notification hub resources with proper tagging
resource "azurerm_resource_group" "main" {
  name     = "${var.resource_group_name_prefix}-${random_string.suffix.result}"
  location = var.location

  lifecycle {
    create_before_destroy = false
  }
}
