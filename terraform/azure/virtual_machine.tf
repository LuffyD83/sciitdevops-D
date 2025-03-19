

# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "K3sVM"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = "Standard_DS1_v2"
  admin_username        = var.username
  
  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # computer_name  = "hostname"


  # admin_ssh_key {
  #   username   = var.username
  #   public_key = azapi_resource_action.ssh_public_key_gen.output.publicKey
  # }

  admin_ssh_key {
    username   = var.username
    public_key = file(".scripts/azure.pem.pub")
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }

  provisioner "local-exec" {
    command = <<EOT
    sleep 90
    chmod 400 /home/runner/work/sciitdevazure-D/sciitdevazure-D/terraform/aws/scripts/devazure.pem
    ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i ${self.public_ip}, -u ubuntu --private-key=./scripts/devazure.pem ./scripts/install_k3s.yml -vv
  EOT
  }
}


# # Create virtual machine
# resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
#   name                  = "WebVM"
#   location              = azurerm_resource_group.rg.location
#   resource_group_name   = azurerm_resource_group.rg.name
#   network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
#   size                  = "Standard_DS1_v2"
#   admin_username        = var.username

#   os_disk {
#     name                 = "myOsDisk"
#     caching              = "ReadWrite"
#     storage_account_type = "Premium_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts-gen2"
#     version   = "latest"
#   }


#   # admin_ssh_key {
#   #   username   = var.username
#   #   public_key = azapi_resource_action.ssh_public_key_gen.output.publicKey
#   # }

#   admin_ssh_key {
#     username   = var.username
#     public_key = file(".scripts/azure.pem.pub")
#   }
#   boot_diagnostics {
#     storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
#   }

#   provisioner "local-exec" {
#     command = <<EOT

#   EOT
#   }
# }


