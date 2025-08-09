variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-3"
}

variable "code_version" {
  type        = string
  description = "Commit SHA to force Lambda update on each push"
  default     = ""
}