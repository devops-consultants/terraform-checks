FROM ghcr.io/aquasecurity/trivy:0.52.0 AS trivy

FROM ghcr.io/terraform-linters/tflint:v0.51.0 AS tflint

FROM quay.io/terraform-docs/terraform-docs:0.17.0 AS terraform-docs

FROM alpine:3.20.2 AS build

RUN apk add --update --no-cache bash git curl gpgv && apk upgrade

# Install tfenv to manage Terraform versions
ENV TFENV_INSTALL_DIR=/usr/local/tfenv
ENV TF_PLUGIN_CACHE_DIR=/root/.terraform.d/plugin-cache
RUN mkdir -p ${TFENV_INSTALL_DIR} && \
    mkdir -p ${TF_PLUGIN_CACHE_DIR}
RUN git clone --depth=1 https://github.com/tfutils/tfenv.git ${TFENV_INSTALL_DIR} && \
    echo 'export PATH="${TFENV_INSTALL_DIR}/bin:$PATH"' >> ~/.bash_profile && \
    echo 'trust-tfenv: yes' > ${TFENV_INSTALL_DIR}/use-gpgv 
ENV PATH=${TFENV_INSTALL_DIR}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


# Install the latest version of Terraform
RUN tfenv install latest && tfenv use latest

# Install tflint to lint Terraform code
COPY --from=tflint /usr/local/bin/tflint /usr/local/bin/tflint

# Install trivy to security scan Terraform code
COPY --from=trivy /usr/local/bin/trivy /usr/local/bin/trivy

# Install Terraform-docs to generate documentation for Terraform code
COPY --from=terraform-docs /usr/local/bin/terraform-docs /usr/local/bin/terraform-docs

RUN wget --no-verbose -P / https://bitbucket.org/bitbucketpipelines/bitbucket-pipes-toolkit-bash/raw/0.6.0/common.sh

COPY LICENSE pipe.yml README.md /

COPY pipe.sh /
RUN chmod a+x /*.sh

ENTRYPOINT ["/pipe.sh"]
