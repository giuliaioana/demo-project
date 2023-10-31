resource "azurerm_virtual_network" "network1" { # vnet creation
  name                = "network1"
  address_space       = ["10.0.0.0/28"]
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_subnet" "subnet1" { # subnet creation
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.network1.name
  address_prefixes     = ["10.0.0.0/29"]
}

resource "azurerm_network_interface" "nic" { # network interface creation
  for_each            = var.vm_map
  name                = "${each.value.name}-nic"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip[each.key].id
  }
}

resource "azurerm_network_security_group" "allow_ssh_nsg" { # security group creation
  name                = "allow_ssh_nsg"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.whitelist_ssh
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_ping_inbound"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_ping_outbound"
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" { # associate securtity group with subnet
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.allow_ssh_nsg.id
}

resource "azurerm_public_ip" "public_ip" { # public ip creation
  for_each = var.vm_map

  name                = "public-ip-${each.key}"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  allocation_method   = "Dynamic"
}
