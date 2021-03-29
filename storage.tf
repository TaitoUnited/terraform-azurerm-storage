/**
 * Copyright 2021 Taito United
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/

resource "azurerm_storage_account" "account" {
  for_each                  = {for item in local.storageAccounts: item.name => item}

  name                      = replace(each.value.name, "-", "")
  resource_group_name       = var.resource_group_name
  location                  = each.value.location
  account_kind              = try(each.value.accountKind, "StorageV2")
  account_tier              = try(each.value.accountTier, "Standard")         # Standard, Premium
  account_replication_type  = try(each.value.accountReplicationType, "ZRS")   # LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS
  access_tier               = try(each.value.accessTier, "Hot")               # Hot, Cool
  enable_https_traffic_only = try(each.value.enableHttpsTrafficOnly, true)
  min_tls_version           = try(each.value.minTlsVersion, "TLS1_0")         # TLS1_0, TLS1_1, TLS1_2
  allow_blob_public_access  = try(each.value.allowBlobPublicAccess, false)
  is_hns_enabled            = try(each.value.isHnsEnabled, true)
  large_file_share_enabled  = try(each.value.largeFileShareEnabled, false)

  tags = {
    purpose   = try(each.value.purpose, "undefined")
  }

  dynamic "network_rules" {
    for_each = each.value.networkRules != null ? [ each.value.networkRules ] : []
    content {
      default_action             = try(network_rules.value.defaultAction, "Deny")
      ip_rules                   = network_rules.value.ipRules
      virtual_network_subnet_ids = network_rules.value.virtualNetworkSubnetIds
    }
  }

  blob_properties {
    dynamic "cors_rule" {
      for_each = try(each.value.corsRule, null) != null ? [ each.value.corsRule ] : []
      content {
        allowed_origins = [ cors_rule.value.allowedOrigins ]
        allowed_methods = try(cors_rule.value.allowedMethods, ["GET","HEAD"])
        allowed_headers = try(cors_rule.value.allowedHeaders, ["*"])
        exposed_headers = try(cors_rule.value.exposedHeaders, ["*"])
        max_age_in_seconds = try(cors_rule.value.maxAgeInSeconds, 5)
      }
    }

    dynamic "delete_retention_policy" {
      for_each = try(each.value.autoDeletionRetainDays, null) != null ? [ each.value.autoDeletionRetainDays ] : []
      content {
        days = delete_retention_policy.value
      }
    }
  }

  # TODO: https://github.com/terraform-providers/terraform-provider-azurerm/issues/8268
  # TODO: implement versioningEnabled, versioningRetainDays
  # TODO: implement hotRetainDays with azurerm_storage_management_policy
  # TODO: implement backupRetainDays

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "container" {
for_each                = {for item in local.storageAccounts: item.name => item}

  name                  = each.value.name
  storage_account_name  = each.value.name
  container_access_type = try(each.value.containerAccessType, "private")

  lifecycle {
    prevent_destroy = true
  }
}
