# Создание ресурсной группы
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_prefix}-rg"
  location = "West Europe" # Укажите нужный регион
}

# Создание виртуальной сети
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Создание подсети
resource "azurerm_subnet" "subnet" {
  name                 = "${var.resource_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Создание группы безопасности сети
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.resource_prefix}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Правило для доступа по SSH
resource "azurerm_network_security_rule" "ssh_rule" {
  name                        = "${var.resource_prefix}-Allow-SSH"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = ["92.119.220.145"]
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
}

# Правило для доступа по HTTP
resource "azurerm_network_security_rule" "http_rule" {
  name                        = "${var.resource_prefix}-Allow-HTTP"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefixes     = ["92.119.220.145"]
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
}

# Первая подсеть
resource "azurerm_subnet" "subnet1" {
  name                 = "${var.resource_prefix}-subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

# Вторая подсеть (оставляем как есть)
resource "azurerm_subnet" "subnet2" {
  name                 = "${var.resource_prefix}-subnet2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Виртуальная машина 1
resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "${var.resource_prefix}-vm1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"  # Укажите нужный размер виртуальной машины
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.vm1_nic.id,
  ]
  disable_password_authentication = true
  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Публичный IP для VM1
resource "azurerm_public_ip" "vm1_public_ip" {
  name                = "${var.resource_prefix}-vm1-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Сетевая карта для VM1 с публичным IP
resource "azurerm_network_interface" "vm1_nic" {
  name                = "${var.resource_prefix}-nic1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm1_public_ip.id
  }
}

# Виртуальная машина 2
resource "azurerm_linux_virtual_machine" "vm2" {
  name                = "${var.resource_prefix}-vm2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"  # Укажите нужный размер виртуальной машины
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.vm2_nic.id,
  ]
  disable_password_authentication = true
  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Публичный IP для VM2
resource "azurerm_public_ip" "vm2_public_ip" {
  name                = "${var.resource_prefix}-vm2-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Сетевая карта для VM2 с публичным IP
resource "azurerm_network_interface" "vm2_nic" {
  name                = "${var.resource_prefix}-nic2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm2_public_ip.id
  }
}