variable "subscription_id" {
  description = "Azure subscription ID that Terraform should target."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name for all provisioned resources."
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created."
  type        = string
}

variable "name_prefix" {
  description = "Prefix applied to Azure resource names."
  type        = string
}

variable "vm_size" {
  description = "Azure VM size for the Docker host."
  type        = string
}

variable "admin_username" {
  description = "Administrator username for the Linux VM."
  type        = string
}

variable "admin_ssh_public_key" {
  description = "SSH public key for the Linux VM administrator."
  type        = string
}

variable "vnet_cidr" {
  description = "CIDR block for the virtual network."
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the web subnet."
  type        = string
}

variable "allowed_http_source_cidr" {
  description = "CIDR allowed to reach the HTTP binding."
  type        = string
}

variable "allowed_ssh_source_cidr" {
  description = "CIDR allowed to reach SSH. Tighten this before using outside a test environment."
  type        = string
}

variable "container_name" {
  description = "Docker container name."
  type        = string
}

variable "image_name" {
  description = "Docker image tag built on the VM."
  type        = string
}

variable "site_port" {
  description = "Public HTTP port exposed on the VM."
  type        = number

  validation {
    condition     = var.site_port > 0 && var.site_port < 65536
    error_message = "site_port must be between 1 and 65535."
  }
}

variable "app_port" {
  description = "Container port exposed by the application image."
  type        = number
}

variable "repo_url" {
  description = "Git repository URL containing the Dockerfile and application source."
  type        = string
}

variable "task_directory" {
  description = "Repository subdirectory that contains the Dockerfile."
  type        = string
}

variable "tags" {
  description = "Tags applied to all Azure resources."
  type        = map(string)
}
