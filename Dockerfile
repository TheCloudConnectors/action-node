FROM node:lts

RUN apk add --no-cache git python2 build-base

RUN npm i -g --force yarn

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

USER node

CMD ["help"]