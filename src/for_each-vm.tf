resource "yandex_compute_instance" "frontend_server" {

  for_each = local.virtual_machines

  name        = each.value.vm_name
  platform_id = "standard-v1"
  resources {
    cores         = each.value.vm_cpu
    memory        = each.value.vm_ram
    core_fraction = each.value.vm_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = each.value.vm_disk_size
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  metadata = local.ssh_keys_and_serial_port

  depends_on = [
    yandex_compute_instance.backend_server
  ]

}
