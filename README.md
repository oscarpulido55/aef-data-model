# Analytics Engineering Framework - Data Model
[Analytics engineers](https://www.getdbt.com/what-is-analytics-engineering) transform, test, deploy, and document data using software engineering principles, providing clean datasets that empower end users to independently answer their own questions.

### Concepts
This reference Data Model management repository is your central hub for streamlined data model definition. It deploys dataform repositories and integrates with BigQuery metadata and [Dataplex](https://cloud.google.com/dataplex) to enable data governance, discoverability, and access control. Here's what it offers:
- **terraform**:
  - Creates BigQuery datasets based on the variables you have in the `dataform.json` files you have in the repositories you reference.
- **data-model:**
  - Create/register Dataplex lakes and zones accordingly.
  - Defines tag templates, policy tags, and governance rules to be applied to data assets.

### Usage
1. **Terraform:** Define your terraform variables.  We recommend creating a `.tfvars` file.
```hcl
project               = "my-project"
region                = "us-central1"
domain                = "my-org-name"
git_token             = "my-git-token-value"
dataform_repositories = {
  sample-repo-1 = {
    remote_repo_url      = "https://github.com/my-dataform-repo.git"
    secret_name          = "my-github-token-secret-1"
    service_account_name = "aef-dataform-repo1-sa"
  },
  ...
}
```
2. **Dataplex:** 
   - Familiarize with [this](https://github.com/GoogleCloudPlatform/cortex-data-foundation/tree/main/docs/data_mesh#concepts) concepts
   - Define metadata in the following `.yaml` files:
     - [Asset Annotations](https://github.com/GoogleCloudPlatform/cortex-data-foundation/tree/main/docs/data_mesh#asset-annotations)
     - [Dataplex Lakes, Zones, and Assets](https://github.com/GoogleCloudPlatform/cortex-data-foundation/tree/main/docs/data_mesh#dataplex-lakes-zones-and-assets)
     - [Policy Taxonomies and Tags](https://github.com/GoogleCloudPlatform/cortex-data-foundation/tree/main/docs/data_mesh#policy-taxonomies-and-tags)
     - [Data Catalog Tag Templates](https://github.com/GoogleCloudPlatform/cortex-data-foundation/tree/main/docs/data_mesh#catalog-tag-templates)
```
└── metadata
│   ├── annotations
│   │   └── annotations.yaml
│   ├── lakes
│   │   └── lakes.yaml
│   ├── policy_taxonomies
│   │   └── policy_taxonomies.yaml
│   └── tag_templates
│       └── tag_templates.yaml
```
1. Run the Terraformn Plan / Apply using the variables you define in the first step.
```commandline
terraform plan -var-file="my-vars.tfvars"
```

## Integration with Analytics Engineering Framework

This opinionated Data Model management repository is designed as a component of a comprehensive Analytics Engineering Framework comprised of:

1. Analytics Engineering Framework - Data Orchestration: Automates the generation of Google Cloud Workflows Definition files.
1. Analytics Engineering Framework - Orchestration Framework: Seamlessly deploy your orchestration infrastructure.
1. Analytics Engineering Framework - Data Transformation: Houses your data transformation logic.
1. Analytics Engineering Framework - Data Model: Manages data models, schemas and Dataplex lakes and zones.