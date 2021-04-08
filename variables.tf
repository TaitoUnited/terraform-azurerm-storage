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

variable "resource_group_name" {
  type = string
}

variable "storage_accounts" {
  type = list(object({
    name = string
    purpose = optional(string)
    location = string
    containerAccessType = optional(string)     # blob, container, private (for the underlying container)

    accountKind = optional(string)
    accountTier = optional(string)             # Standard, Premium
    accountReplicationType = optional(string)  # LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS
    accessTier = optional(string)              # Hot, Cool
    enableHttpsTrafficOnly = optional(bool)
    minTlsVersion = optional(string)           # TLS1_0, TLS1_1, TLS1_2
    isHnsEnabled = optional(bool)
    largeFileShareEnabled = optional(bool)

    networkRules = optional(object({
      defaultAction = string
      ipRules = list(string)
      virtualNetworkSubnetIds = list(string)
    }))

    # TODO: cdnDomain
    cdnDomain = optional(string)

    corsRules = optional(list(object({
      allowedOrigins = optional(list(string))
      allowedMethods = optional(list(string))
      allowedHeaders = optional(list(string))
      exposedHeaders = optional(list(string))
      maxAgeSeconds = optional(number)
    })))

    # TODO: versioningEnabled = optional(bool)
    # TODO: versioningRetainDays = optional(number)
    # TODO: hotRetainDays = optional(number)
    # TODO: backupRetainDays = optional(number)
    autoDeletionRetainDays = optional(number)

    allowBlobPublicAccess = optional(bool)

    # TODO: members not implemented
    members = optional(list(object({
      id = string
      roles = list(string)
    })))
  }))
  default     = []
  description = "Resources as JSON (see README.md). You can read values from a YAML file with yamldecode()."
}
