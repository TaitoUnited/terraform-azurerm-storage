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

provider "azurerm" {
  features {}
}

locals {
  storageAccounts = var.storage_accounts

  cdnStorageAccounts = flatten([
    for account in local.storageAccounts:
    coalesce(account.cdnDomain, "") != "" ? [ account ] : []
  ])

  storageAccountMembers = flatten([
    for account in local.storageAccounts: [
      for member in (account.members != null ? account.members : []): [
        for role in coalesce(member.roles != null ? member.roles : []):
        {
          key    = "${account.name}-${member.id}-${role}"
          account = account.name
          member = member.id
          role = role
        }
      ]
    ]
  ])
}
