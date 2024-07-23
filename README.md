# Bitbucket Pipelines Pipe: terraform-checks

A BitBucket Pipe for performing best practise checks on terraform module code.

## YAML Definition

Add the following snippet to the script section of your `bitbucket-pipelines.yml` file:

```yaml
script:
  - pipe: devopsconsultants/terraform-checks:0.1.0
    variables:
      NAME: "<string>"
      # DEBUG: "<boolean>" # Optional
```

## Variables

| Variable  | Usage                                              |
| --------- | -------------------------------------------------- |
| NAME (\*) | The name that will be printed in the logs          |
| DEBUG     | Turn on extra debug information. Default: `false`. |

_(\*) = required variable._

## Prerequisites

## Examples

Basic example:

```yaml
script:
  - pipe: devopsconsultants/terraform-checks:0.1.0
    variables:
      NAME: "foobar"
```

Advanced example:

```yaml
script:
  - pipe: devopsconsultants/terraform-checks:0.1.0
    variables:
      NAME: "foobar"
      DEBUG: "true"
```
