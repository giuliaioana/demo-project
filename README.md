# Demo project

## Local dev pre-requirmnets
```
brew install terraform
brew install pre-commit
brew install terraform-docs
brew install tflint
brew install tfsec
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.78.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_security_group.allow_ssh_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.subnet1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.nsg_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.network1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [null_resource.ping_tests](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | admin user | `string` | n/a | yes |
| <a name="input_vm_map"></a> [vm\_map](#input\_vm\_map) | n/a | <pre>map(object({<br>    name      = string<br>    size      = string<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  }))</pre> | <pre>{<br>  "vm1": {<br>    "name": "vm1",<br>    "offer": "UbuntuServer",<br>    "publisher": "Canonical",<br>    "size": "Standard_B2s",<br>    "sku": "18.04-LTS",<br>    "version": "latest"<br>  },<br>  "vm2": {<br>    "name": "vm2",<br>    "offer": "UbuntuServer",<br>    "publisher": "Canonical",<br>    "size": "Standard_B1s",<br>    "sku": "18.04-LTS",<br>    "version": "latest"<br>  }<br>}</pre> | no |
| <a name="input_whitelist_ssh"></a> [whitelist\_ssh](#input\_whitelist\_ssh) | Local SSH IP range | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ping_results"></a> [ping\_results](#output\_ping\_results) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
