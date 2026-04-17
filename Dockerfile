FROM node:lts-alpine3.19

ENV AWSCLI_VERSION='1.18.69'

RUN apk add --no-cache git python3 py-pip build-base libxml2 libxml2-utils

RUN pip install --quiet --no-cache-dir awscli==${AWSCLI_VERSION} --break-system-packages

RUN npm i -g --force yarn

# Install Aikido Safe Chain v1.4.9 for supply chain protection
# Config: 30-day minimum package age, exclude @thecloudconnectors scope
# All in one layer to ensure permissions are correct
RUN apk add --no-cache curl && \
    curl -fsSL https://github.com/AikidoSec/safe-chain/releases/download/1.4.9/install-safe-chain.sh | sh -s -- --ci && \
    apk del curl && \
    printf '{"minimumPackageAgeHours":720,"npm":{"minimumPackageAgeExclusions":["@thecloudconnectors/*"]}}\n' > /root/.safe-chain/config.json && \
    chmod a+rwx /root && \
    chmod -R a+rwx /root/.safe-chain

ENV PATH="/root/.safe-chain/shims:/root/.safe-chain/bin:${PATH}"
ENV SAFE_CHAIN_MINIMUM_PACKAGE_AGE_HOURS=720
ENV SAFE_CHAIN_LOGGING=normal

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER node

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
