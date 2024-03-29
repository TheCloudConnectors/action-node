FROM node:lts-alpine3.19

ENV AWSCLI_VERSION='1.18.69'

RUN apk add --no-cache git python3 py-pip build-base libxml2 libxml2-utils

RUN pip install --quiet --no-cache-dir awscli==${AWSCLI_VERSION} --break-system-packages

RUN npm i -g --force yarn

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

USER node

CMD ["help"]