FROM alpine:3.20

RUN apk add --update --no-cache bash git curl gpgv tflint

# Install tfenv to manage Terraform versions
ENV TFENV_INSTALL_DIR=/usr/local/tfenv
RUN git clone --depth=1 https://github.com/tfutils/tfenv.git ${TFENV_INSTALL_DIR} && \
    echo 'export PATH="${TFENV_INSTALL_DIR}/bin:$PATH"' >> ~/.bash_profile && \
    echo 'trust-tfenv: yes' > ${TFENV_INSTALL_DIR}/use-gpgv && \
    echo "plugin_cache_dir = \"/root/.terraform.d/plugin-cache\"" > /root/.terraformrc
ENV PATH=${TFENV_INSTALL_DIR}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


# Install the latest version of Terraform
RUN tfenv install latest && tfenv use latest

# Install trivy to security scan Terraform code
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

RUN wget --no-verbose -P / https://bitbucket.org/bitbucketpipelines/bitbucket-pipes-toolkit-bash/raw/0.6.0/common.sh

COPY LICENSE pipe.yml README.md /

COPY pipe.sh /
RUN chmod a+x /*.sh

ENTRYPOINT ["/pipe.sh"]
