# Bitbucket Pipelines Pipe: terraform-checks

A BitBucket Pipe for performing best practise checks on terraform module code.

## YAML Definition

Add the following snippet to the script section of your `bitbucket-pipelines.yml` file:

```yaml
script:
  - pipe: docker://quay.io/devops_consultants/terraform-checks:latest
    variables:
      TF_MODULE_PATH: "<string>"
      # DEBUG: "<boolean>" # Optional
```

## Variables

| Variable            | Usage                                              |
| ------------------- | -------------------------------------------------- |
| TF_MODULE_PATH (\*) | The path to the module                             |
| DEBUG               | Turn on extra debug information. Default: `false`. |
| RUN_FMT             | Run Terraform Format. Default: `true`.             |
| RUN_VALIDATE        | Run Terraform Validate. Default: `true`.           |
| RUN_TFLINT          | Run tflint. Default: `true`                        |
| RUN_TRIVY           | Run trivy. Default: `true`                         |

_(\*) = required variable._

## Prerequisites

## Examples

Basic example:

```yaml
script:
  - pipe: docker://quay.io/devops_consultants/terraform-checks:latest
    variables:
      TF_MODULE_PATH: "modules/foobar"
```

Advanced example:

```yaml
script:
  - pipe: docker://quay.io/devops_consultants/terraform-checks:latest
    variables:
      TF_MODULE_PATH: "modules/foobar"
      DEBUG: "true"
```
