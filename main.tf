# Copyright [2024] [Bruno Kaiser]

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# http://www.apache.org/licenses/LICENSE-2.0
# SPDX-License-Identifier: Apache-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

terraform {
  required_version = "~> 1.8"
}

# Enable required APIs for Cloud Firestore.
resource "google_project_service" "firestore" {
  provider                        = google-beta
  project                         = var.project_id
  for_each                        = toset([
    "firestore.googleapis.com",
    "firebaserules.googleapis.com",
  ])
  service                          = each.key

  # Don't disable the service if the resource block is removed by accident.
  disable_on_destroy = false
}

# Provision the Firestore database instance.
resource "google_firestore_database" "default" {
  provider                        = google-beta
  project                         = var.project_id
  name                            = "(default)"
  location_id                     = var.location
  # "FIRESTORE_NATIVE" is required to use Firestore with Firebase SDKs,
  # authentication, and Firebase Security Rules.
  type                            = "FIRESTORE_NATIVE"
  concurrency_mode                = "OPTIMISTIC"

  depends_on = [
    google_project_service.firestore
  ]
}

# Create a ruleset of Firestore Security Rules from a local file.
resource "google_firebaserules_ruleset" "firestore" {
  provider = google-beta
  project  = var.project_id
  source {
    files {
      name                          = "firestore.rules"
      # Write security rules in a local file named "firestore.rules".
      # Learn more: https://firebase.google.com/docs/firestore/security/get-started
      content                       = file("${path.module}/firestore.rules")
    }
  }

  # Wait for Firestore to be provisioned before creating this ruleset.
  depends_on = [
    google_firestore_database.default,
  ]
}

# Release the ruleset for the Firestore instance.
resource "google_firebaserules_release" "firestore" {
  provider                          = google-beta
  name                              = "cloud.firestore"  # must be cloud.firestore
  ruleset_name                      = google_firebaserules_ruleset.firestore.name
  project                           = var.project_id

  # Wait for Firestore to be provisioned before releasing the ruleset.
  depends_on = [
    google_firestore_database.default,
  ]

  lifecycle {
    replace_triggered_by = [
      google_firebaserules_ruleset.firestore
    ]
  }
}
