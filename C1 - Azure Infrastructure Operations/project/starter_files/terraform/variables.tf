variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
}

variable "username" {
  description = "The username of the account of the vm"
}

variable "vm_machine_count" {
  description = "The number of virtual machines to deploy"
  type = number
  default = 3
}