provider "azurerm" {
  features {}
}

run "setup" {
  module {
    source = "./tests/setup/dependencies"
  }
}

run "examples_apply" {
  command = apply

  variables {
    diagnostic_settings = run.setup.diagnostic_settings
    enable_telemetry    = false # Disabled for testing. 
    location            = run.setup.azurerm_resource_group.location
    name                = run.setup.naming.kusto_cluster.name_unique
    private_endpoints   = run.setup.private_endpoints
    resource_group_name = run.setup.azurerm_resource_group.name
  }
  # make sure you reference the -var-file from the examples folders to inject the configuration
  # terraform test --verbose -filter=tests/examples_apply.tftest.hcl -var-file examples/cluster_with_databases/terraform.tfvars

  assert {
    condition     = azurerm_kusto_cluster.this.name == run.setup.naming.kusto_cluster.name_unique
    error_message = "Cluster name does not match the input variable."
  }

  assert {
    condition     = azurerm_kusto_cluster.this.resource_group_name == run.setup.azurerm_resource_group.name
    error_message = "Resource group name does not match the input variable."
  }

  assert {
    condition     = azurerm_kusto_cluster.this.location == run.setup.azurerm_resource_group.location
    error_message = "Resource group location does not match the input variable."
  }

  assert {
    condition     = azurerm_kusto_cluster.this.sku[0] == var.sku
    error_message = "Sku does not match the input variable."
  }
}