variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "kubernetes_cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
}

variable "dns_prefix" {
  description = "The DNS prefix for the AKS cluster"
  type        = string
}

variable "node_pool_name" {
  description = "The name of the default node pool"
  type        = string
}

variable "node_count" {
  description = "The number of nodes in the default node pool"
  type        = number
}

variable "vm_size" {
  description = "The size of the VM instances in the default node pool"
  type        = string
}

variable "network_plugin" {
  description = "The network plugin to use for the AKS cluster"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the AKS cluster"
  type        = map(string)
}

variable "chart_name" {
  description = "The name of the Helm chart"
  type        = string
}

variable "chart_namespace" {
  description = "The namespace where the Helm chart will be installed"
  type        = string
}

variable "chart_version" {
  description = "The version of the Helm chart"
  type        = string
}

variable "acr_name" {
  description = "The name of the Azure Container Registry"
  type        = string
}

variable "values" {
  description = "List of values to set in the Helm chart"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "sensitive_values" {
  description = "List of sensitive values to set in the Helm chart"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

