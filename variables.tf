variable "vm_map" {
  type = map(object({
    name      = string
    size      = string
    publisher = string
    offer     = string
    sku       = string
    version   = string
  }))

  default = {
    "vm1" = {
      name      = "vm1"
      size      = "Standard_B2s"
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
    "vm2" = {
      name      = "vm2"
      size      = "Standard_B1s"
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
  }
}

# define the vms in this map

variable "admin_username" {
  type        = string
  description = "admin user"
}

variable "whitelist_ssh" {
  type        = string
  description = "Local SSH IP range"
}
