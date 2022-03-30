provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resource-group"
  location = var.location

  tags = {
    project = "nd-prj1"
  }
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    project = "nd-prj1"
  }
}


resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id          = azurerm_public_ip.main.id
  }

  tags = {
    project = "nd-prj1"
  }
}

resource "azurerm_public_ip" "main"{
  name                = "${var.prefix}-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method       = "Static"

  tags = {
    project = "nd-prj1"
  }
}

resource "azurerm_lb" "main" {
  name                = "${var.prefix}-lb"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  frontend_ip_configuration {
    name                 = "internal"
    public_ip_address_id = azurerm_public_ip.main.id
  }

  tags = {
    project = "nd-prj1"
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  name            = "${var.prefix}-lb-backend-pool"
  loadbalancer_id = data.azurerm_lb.main.id
}

resource "azurerm_lb_backend_address_pool_address" "main" {
  name                    = "${var.prefix}-lb-backend-pool-address"
  backend_address_pool_id = data.azurerm_lb_backend_address_pool.main.id
  virtual_network_id      = data.azurerm_virtual_network.main.id
  ip_address              = "10.0.0.10"
}

resource "azurerm_availability_set" "main" {
  name                = "${var.prefix}-avail-set"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    project = "nd-prj1"
  }

}

resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowSubnetAccess"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = {
    project = "nd-prj1"
  }
}


resource "azurerm_linux_virtual_machine" "main" {
  count                           = var.vm_machine_count
  name                            = "${var.prefix}-vm-${count.index}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_B1s"
  admin_username                  = "${var.username}"
   admin_ssh_key {
    username   = "${var.username}"
    public_key = file("~/.ssh/id_rsa.pub")
  } 
  disable_password_authentication = true
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]
  availability_set_id = azurerm_availability_set.main.id

  source_image_id = 

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    project = "nd-prj1"
  }
}


resource "azurerm_managed_disk" "main" {
  name                 = "${var.prefix}-managed-disk"
  location             = urerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1024"

  tags = {
    project = "nd-prj1"
  }

}

resource "azurerm_virtual_machine_data_disk_attachment" "main" {
  virtual_machine_id = azurerm_linux_virtual_machine.main.id
  managed_disk_id    = azurerm_managed_disk.main.id
  lun                = 0
  caching            = "None"
}