output "ping_results" {
  depends_on = [null_resource.ping_tests]
  value = [
    for idx, _ in azurerm_linux_virtual_machine.vm : {
      source_instance_name = azurerm_linux_virtual_machine.vm[idx].name
      target_instance_name = azurerm_linux_virtual_machine.vm[local.vm_list[(index(local.vm_list, idx) + 1) % length(var.vm_map)]].name
      ping_result          = can(file("ping_output_${idx}.txt")) ? file("ping_output_${idx}.txt") : null
    }
  ]
}
