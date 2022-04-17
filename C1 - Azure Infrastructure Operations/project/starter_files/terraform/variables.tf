variable "prefix" {
  description = "The prefix for all resources in the template"
  default = "nd-prj1"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "Germany West Central"
}

variable "username" {
  description = "The username of the account of the vm"
  default = "admin_user"
}

variable "source_image_name" {
  description = "The name of the source image for the vm"
  default = "nd-prj1-server-image"
}

variable "source_image_rg" {
  description = "The name of the resource group of the source image for the vm"
  default = "packer-img-rg"
}

variable "vm_machine_count" {
  description = "The number of virtual machines to deploy"
  type = number
  default = 3
}