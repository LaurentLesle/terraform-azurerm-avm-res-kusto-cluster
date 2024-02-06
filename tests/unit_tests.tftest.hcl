mock_provider "azurerm" {}

run "validation_rules_required_pass" {
  variables {
    name                = "demo"
    resource_group_name = "demo"
    location            = "southeastasia"
    sku = {
      name     = "Dev(No SLA)_Standard_D11_v2"
      capacity = 1
    }
  }

  assert {
    condition     = azurerm_kusto_cluster.this.name == var.name
    error_message = "Name is not equals to input variable."
  }

  assert {
    condition     = azurerm_kusto_cluster.this.resource_group_name == var.resource_group_name
    error_message = "resource_group_name is not equals to input variable."
  }

  assert {
    condition     = azurerm_kusto_cluster.this.location == var.location
    error_message = "location is not equals to input variable."
  }

  assert {
    condition     = azurerm_kusto_cluster.this.sku[0] == var.sku
    error_message = "sku is not equals to input variable."
  }
}

run "validation_rules_optional_pass" {
  variables {
    name                = "demo"
    resource_group_name = "demo"
    location            = "southeastasia"
    sku = {
      name     = "Dev(No SLA)_Standard_D11_v2"
      capacity = 1
    }
    allowed_fqdns       = ["demo.demo.com"]
    allowed_ip_ranges   = ["192.168.0.0/24"]
    enable_telemetry    = false
    language_extensions = ["PYTHON", "R"]
    lock = {
      name = "Lock. name"
      kind = "CanNotDelete"
    }
    managed_identities = {
      type = "SystemAssigned, UserAssigned"
    }
    optimized_auto_scale = {
      minimum_instances = 50
      maximum_instances = 2
    }
    public_ip_type           = "IPv4"
    trusted_external_tenants = ["*"]
    zones                    = ["1", "2", "3"]
  }

  assert {
    condition     = azurerm_kusto_cluster.this.name == var.name
    error_message = "Name is not equals to input variable."
  }

  assert {
    condition     = azurerm_kusto_cluster.this.resource_group_name == var.resource_group_name
    error_message = "resource_group_name is not equals to input variable."
  }

  assert {
    condition     = azurerm_kusto_cluster.this.location == var.location
    error_message = "location is not equals to input variable."
  }

  assert {
    condition     = azurerm_kusto_cluster.this.sku[0] == var.sku
    error_message = "sku is not equals to input variable."
  }

  assert {
    condition     = setunion(azurerm_kusto_cluster.this.allowed_fqdns, var.allowed_fqdns) == var.allowed_fqdns
    error_message = "allowed_fqdns is not equals to input variable."
  }

  assert {
    condition     = setunion(azurerm_kusto_cluster.this.allowed_ip_ranges, var.allowed_ip_ranges) == var.allowed_ip_ranges
    error_message = "allowed_ip_ranges is not equals to input variable."
  }

  assert {
    condition     = azurerm_kusto_cluster.this.identity[0].type == var.managed_identities.type
    error_message = "Managed identity is not equals to input variable."
  }

  assert {
    condition     = azurerm_kusto_cluster.this.language_extensions == var.language_extensions
    error_message = "language_extensions is not equals to input variable."
  }

  assert {
    condition     = azurerm_kusto_cluster.this.optimized_auto_scale[0] == var.optimized_auto_scale
    error_message = "optimized_auto_scale is not equals to input variable."
  }

  assert {
    condition     = azurerm_kusto_cluster.this.public_ip_type == var.public_ip_type
    error_message = "public_ip_type is not equals to input variable."
  }

  assert {
    condition     = azurerm_kusto_cluster.this.zones == var.zones
    error_message = "zones is not equals to input variable."
  }

  assert {
    condition     = var.enable_telemetry ? can(azurerm_management_lock.this[0]) : true
    error_message = "enable_telemetry is not equals to input variable."
  }
}

run "validation_rules_fails" {
  command = plan

  variables {
    name                = "de"
    resource_group_name = "demo"
    location            = "southeastasia"
    sku = {
      name     = "Dev(No SLA)_Standard_D11_v20"
      capacity = 1
    }
    enable_telemetry    = false
    language_extensions = ["PYTHONXXX", "Y"]
    lock = {
      name = "Lock. name"
      kind = "Fails"
    }
  }

  expect_failures = [
    var.name, var.sku, var.language_extensions,
    var.lock
  ]
}