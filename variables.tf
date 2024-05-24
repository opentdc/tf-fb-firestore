variable "project_id" {
  description = "The Firebase project ID."
  type        = string
}

variable "location" {
  description = "Hosting center where the Firestore database and Cloud Storage bucket will be provisioned. This must be the same as for the default Cloud Storage bucket."
  type        = string
  default     = "europe-west6"
}