resource "azurerm_resource_group" "rg1" { # crearea resource group, rg1
  name     = "rg1"
  location = "West Europe"
}

resource "random_password" "password" { # crearea de parole random cu anumite specificatii
  for_each = var.vm_map
  length   = 16
  special  = true
}

resource "azurerm_linux_virtual_machine" "vm" { # crearea vm-urilor
  for_each = var.vm_map

  name                = each.value.name
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  size                            = each.value.size # vm flavor
  admin_username                  = var.admin_username
  admin_password                  = random_password.password[each.key].result
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference { # vm image
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }

}

locals {
  vm_list = [for key, value in var.vm_map : key] # vm_list = [vm1, vm2]
}

resource "null_resource" "ping_tests" {
  count = length(local.vm_list) # count = 2

  triggers = {
    source_instance_name = azurerm_linux_virtual_machine.vm[local.vm_list[count.index]].name                               # vm1.name
    target_instance_name = azurerm_linux_virtual_machine.vm[local.vm_list[(count.index + 1) % length(local.vm_list)]].name # vm2.name
    # am folosit operatorul modulo pentru a ma asigura ca ultima masina din lista o sa poata sa dea ping la prima
    # pentru ultimul index nu se mai poate calcula index + 1, prin urmare daca ultimul index = 1 => (1 + 1) % 2 = 2 % 2 = 0 => vm[1] o sa dea ping la vm[0]
    # always_run         = "${timestamp()}"

  }

  connection {
    type     = "ssh"
    user     = var.admin_username
    password = azurerm_linux_virtual_machine.vm[local.vm_list[count.index]].admin_password
    host     = azurerm_linux_virtual_machine.vm[local.vm_list[count.index]].public_ip_address
  }
  # pentru a putea da ping de pe o masina pe alta trebuie sa folosim remote exec si pentru a putea sa dam comanda de ping de pe o masina
  # trebuie sa ne conectam prin ssh la masina respectiva - am dat ssh cu admin_username si cu parola

  provisioner "remote-exec" {
    inline = [
      "ping -c 3 ${azurerm_linux_virtual_machine.vm[local.vm_list[(count.index + 1) % length(var.vm_map)]].private_ip_address} > /tmp/ping_output.txt"
    ]
    # de pe vm1 ( index = 0 ) -> ping vm[vm_list[1]].private_ip = ping vm[vm2].private_ip > ping_output.txt
  }
  provisioner "local-exec" {
    command = "sshpass -p '${azurerm_linux_virtual_machine.vm[local.vm_list[count.index]].admin_password}' scp -o StrictHostKeyChecking=no ${var.admin_username}@${azurerm_linux_virtual_machine.vm[local.vm_list[count.index]].public_ip_address}:/tmp/ping_output.txt ping_output_${local.vm_list[count.index]}.txt"
  }
  # de pe local ne conectam prin ssh la fiecare masina si copiem cu scp admin_username@public_ip fiecare ping_output.txt pe care il vom numi ping_output_v1.txt si ping_output_v2.txt
}
