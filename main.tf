variable "prefix" {
  default = "test"
}

variable "computer_name" {}
variable "user" {}
variable "password" {}

resource "azurerm_resource_group" "test" {
  name     = "Test"
  location = "Central US"
}

resource "azurerm_network_security_group" "test" {
  name                = "secgroup001"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  security_rule {
    name                        = "WinRM"
    priority                    = 101
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "5986"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }

  security_rule {
    name                        = "DenySSH"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }

  security_rule {
    name                        = "RDP"
    priority                    = 102
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
}

resource "azurerm_virtual_network" "test" {
  name                = "${var.prefix}-network"
  address_space       = ["10.10.0.0/16"]
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
}

resource "azurerm_subnet" "test" {
  name                 = "internal"
  resource_group_name  = "${azurerm_resource_group.test.name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  address_prefix       = "10.10.0.0/24"
}

resource "azurerm_network_interface" "test" {
  count               = 3
  name                = "${var.prefix}-nic${count.index}"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  ip_configuration {
    name                          = "config${count.index}"
    subnet_id                     = "${azurerm_subnet.test.id}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "test" {
  count                 = 3
  name                  = "${var.prefix}-vm${count.index}"
  location              = "${azurerm_resource_group.test.location}"
  resource_group_name   = "${azurerm_resource_group.test.name}"
  network_interface_ids = ["${azurerm_network_interface.test.*.id[count.index]}"]
  vm_size               = "Standard_DS1_v2"

  tags {
    Name = "vm-${count.index}"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2012-R2-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.prefix}-storage${count.index}"
    caching           = "ReadOnly"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.computer_name}"
    admin_username = "${var.user}"
    admin_password = "${var.password}"
  }

  os_profile_windows_config {
    provision_vm_agent = false
  }
}
