locals {
  container_bootstrap_script = templatefile("${path.module}/scripts/bootstrap-container.sh.tftpl", {
    app_port        = var.app_port
    container_name  = var.container_name
    image_name      = var.image_name
    repo_url        = var.repo_url
    site_port       = var.site_port
    task_directory  = var.task_directory
  })

  container_bootstrap_command = join(" ", [
    "bash",
    "-lc",
    "\"mkdir -p /opt/task3 && echo '${base64encode(local.container_bootstrap_script)}' | base64 -d > /opt/task3/bootstrap-container.sh && chmod +x /opt/task3/bootstrap-container.sh && /opt/task3/bootstrap-container.sh\"",
  ])
}

resource "azurerm_virtual_machine_extension" "container" {
  name                 = "${var.name_prefix}-container-bootstrap"
  virtual_machine_id   = azurerm_linux_virtual_machine.web.id
  publisher = "Microsoft.Azure.Extensions"
  type      = "CustomScript"
  type_handler_version = "2.1"

  settings = jsonencode({
    commandToExecute = local.container_bootstrap_command
  })

  depends_on = [
    azurerm_linux_virtual_machine.web,
    azurerm_subnet_network_security_group_association.web,
  ]
}
