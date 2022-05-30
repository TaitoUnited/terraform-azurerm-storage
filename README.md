# Azure storage

Example usage:

```
provider "azurerm" {
  features {}
}

module "storage" {
  source              = "TaitoUnited/storage/azurerm"
  version             = "1.0.0"

  resource_group_name = "my-infrastructure"
  storage_accounts    = yamldecode(file("${path.root}/../infra.yaml"))["storageAccounts"]
}
```

Example YAML:

```
storageAccounts:
  - name: zone1-state
    purpose: state
    location: northeurope
    accountTier: Standard
    accessTier: Hot
    accountReplicationType: ZRS
    containerAccessType: private
    allowNestedItemsToBePublic: false
    versioningEnabled: true        # TODO: implement
    versioningRetainDays: 60       # TODO: implement

  - name: zone1-locked-backup
    purpose: backup
    location: northeurope
    accountTier: Standard
    accessTier: Cool
    accountReplicationType: GRS
    containerAccessType: private
    allowNestedItemsToBePublic: false
    versioningEnabled: false
    lockRetainDays: 100            # TODO: implement
    autoDeletionRetainDays: 0      # TODO: implement

  - name: zone1-public
    purpose: public
    location: northeurope
    accountTier: Standard
    accessTier: Hot
    accountReplicationType: ZRS
    containerAccessType: blob
    allowNestedItemsToBePublic: true
    versioningEnabled: true        # TODO: implement
    versioningRetainDays: 60       # TODO: implement
    cdnDomain: cdn.mydomain.com    # TODO: implement
    corsRules:
      - allowedOrigins: ["*"]
    members:                       # TODO: implement
      - id: "cicd-serviceaccount"
        roles: [ "objectCreator" ]
```

YAML attributes:

- See variables.tf for all the supported YAML attributes.
- See [storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) and [storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) for attribute descriptions.

Combine with the following modules to get a complete infrastructure defined by YAML:

- [Admin](https://registry.terraform.io/modules/TaitoUnited/admin/azurerm)
- [DNS](https://registry.terraform.io/modules/TaitoUnited/dns/azurerm)
- [Network](https://registry.terraform.io/modules/TaitoUnited/network/azurerm)
- [Compute](https://registry.terraform.io/modules/TaitoUnited/compute/azurerm)
- [Kubernetes](https://registry.terraform.io/modules/TaitoUnited/kubernetes/azurerm)
- [Databases](https://registry.terraform.io/modules/TaitoUnited/databases/azurerm)
- [Storage](https://registry.terraform.io/modules/TaitoUnited/storage/azurerm)
- [Monitoring](https://registry.terraform.io/modules/TaitoUnited/monitoring/azurerm)
- [Integrations](https://registry.terraform.io/modules/TaitoUnited/integrations/azurerm)
- [PostgreSQL privileges](https://registry.terraform.io/modules/TaitoUnited/privileges/postgresql)
- [MySQL privileges](https://registry.terraform.io/modules/TaitoUnited/privileges/mysql)

TIP: Similar modules are also available for AWS, Google Cloud, and DigitalOcean. All modules are used by [infrastructure templates](https://taitounited.github.io/taito-cli/templates#infrastructure-templates) of [Taito CLI](https://taitounited.github.io/taito-cli/). See also [Azure project resources](https://registry.terraform.io/modules/TaitoUnited/project-resources/azurerm), [Full Stack Helm Chart](https://github.com/TaitoUnited/taito-charts/blob/master/full-stack), and [full-stack-template](https://github.com/TaitoUnited/full-stack-template).

Contributions are welcome!
