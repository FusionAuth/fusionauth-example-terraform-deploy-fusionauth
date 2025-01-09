variable "postgres_user" {
  description = "The postgres user"
  type        = string
  default     = ""
  sensitive   = true
}
variable "postgres_password" {
  description = "The postgres password"
  type        = string
  default     = ""
  sensitive   = true
}
variable "pgdata" {
  description = "The postgres data directory"
  type        = string
  default     = ""
  sensitive   = true
}
variable "fusionauth_database_username" {
  description = "The fusionauth database user"
  type        = string
  default     = ""
  sensitive   = true
}
variable "fusionauth_database_password" {
  description = "The fusionauth database password"
  type        = string
  default     = ""
  sensitive   = true
}
variable "fusionauth_app_memory" {
  description = "The fusionauth app memory setting"
  type        = string
  default     = ""
  sensitive   = true
}
variable "fusionauth_app_runtime_mode" {
  description = "The fusionauth app runtime mode"
  type        = string
  default     = ""
  sensitive   = true
}
