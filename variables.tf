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
    purpose = string
    location = string
    containerAccessType = string     # blob, container, private (for the underlying container)

    accountKind = string
    accountTier = string             # Standard, Premium
    accountReplicationType = string  # LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS
    accessTier = string              # Hot, Cool
    enableHttpsTrafficOnly = bool
    minTlsVersion = string           # TLS1_0, TLS1_1, TLS1_2
    isHnsEnabled = bool
    largeFileShareEnabled = bool

    networkRules = object({
      defaultAction = string
      ipRules = list(string)
      virtualNetworkSubnetIds = list(string)
    })

    # TODO: cdnDomain = string

    corsRules = list(object({
      allowedOrigins = list(string)
      allowedMethods = list(string)
      allowedHeaders = list(string)
      exposedHeaders = list(string)
      maxAgeInSeconds = number
    }))

    # TODO: versioningEnabled = bool
    # TODO: versioningRetainDays = number
    # TODO: hotRetainDays = number
    # TODO: backupRetainDays = number
    autoDeletionRetainDays = number

    allowBlobPublicAccess = bool

    # TODO: members not implemented
    members = list(object({
      id = string
      roles = list(string)
    }))
  }))
  default     = []
  description = "Resources as JSON (see README.md). You can read values from a YAML file with yamldecode()."
}
