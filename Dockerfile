FROM node:lts-alpine3.19

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

USER node

CMD ["help"]
