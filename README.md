# Terraform module to create a Firestore database 

This is a Terraform module to install Firebase Firestore database including an initial set of access rules. 
It requires the [Google Cloud SDK][] to be installed locally and an
existing [Firebase project][Firebase console]. 

To get started:

1.  Install the [Google Cloud SDK][], [Terraform][Terraform install], and
    [Git][Git install].

2.  Create a [Firebase project][Firebase console] with the Blaze Plan.

3.  Add the following config to your terraform tf file:

    ```
    module "tf-fb-firestore" {
        source            = "github.com/opentdc/tf-fb-firestore"
        project_id        = local.project_id
        location          = local.location
    }
    ```

4.  Run `terraform init && terraform apply`


## Input variables

| Variable Name               | Type      | Usage       | Default         | Description                                        |
|-----------------------------|-----------|-------------|-----------------|----------------------------------------------------|
| project_id                  | string    | mandatory   |                 | The Firebase project ID                            |
| location                    | string    | mandatory   |                 | Hosting center where the Firestore database and    |
|                             |           |             |                 | Cloud storage bucket will be provisioned.          |
|                             |           |             |                 | This must be the same as the storage location.     |


## Output
None