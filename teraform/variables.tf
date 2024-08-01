variable "acr_server" {
  description = "The instance ACR server name"
  type        = string
}

variable "acr_server_subscription" {
  description = "The Azure subscription ID for the instance ACR"
  type        = string
}

variable "source_acr_client_id" {
  description = "The client ID for accessing the source ACR"
  type        = string
}

variable "source_acr_client_secret" {
  description = "The client secret for accessing the source ACR"
  type        = string
}

variable "source_acr_server" {
  description = "The source ACR server name"
  type        = string
}

variable "charts" {
  description = "The list of charts to be imported and installed"
  type = list(object({
    chart_name       = string
    chart_namespace  = string
    chart_repository = string
    chart_version    = string
    values = list(object({
      name  = string
      value = string
    }))
    sensitive_values = list(object({
      name  = string
      value = string
    }))
  }))
}

