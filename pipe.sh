#!/usr/bin/env bash

set -e

source "$(dirname "$0")/common.sh"

info "Running module tests"

# Required parameters
TF_MODULE_PATH=${TF_MODULE_PATH:?"TF_MODULE_PATH env variable is required"}

# Default values
DEBUG=${DEBUG:="false"}
RUN_TFLINT=${RUN_TFLINT:="true"}
RUN_TRIVY=${RUN_TRIVY:="true"}
RUN_VALIDATE=${RUN_VALIDATE:="true"}
RUN_FMT=${RUN_FMT:="true"}

enable_debug() {
  if [[ "${DEBUG}" == "true" ]]; then
    info "Enabling debug mode."
    set -x
  fi
}
enable_debug

cd ${TF_MODULE_PATH}

if [[ "${RUN_FMT}" == "true" ]]; then
  info "Checking module formatting"
  run terraform init && terraform fmt -check

  if [[ "${status}" == "0" ]]; then
    success "Success!"
  else
    fail "Error!"
  fi
fi

if [[ "${RUN_VALIDATE}" == "true" ]]; then
  info "Checking module validation"
  run terraform validate

  if [[ "${status}" == "0" ]]; then
    success "Success!"
  else
    fail "Error!"
  fi
fi


if [[ "${RUN_TFLINT}" == "true" ]]; then
  info "Checking module linting"
  run tflint

  if [[ "${status}" == "0" ]]; then
    success "Success!"
  else
    fail "Error!"
  fi
fi

if [[ "${RUN_TRIVY}" == "true" ]]; then
  info "Checking module vulnerabilities"
  run trivy config .

  if [[ "${status}" == "0" ]]; then
    success "Success!"
  else
    fail "Error!"
  fi
fi
