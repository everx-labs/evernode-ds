FROM node:14-buster

USER node

WORKDIR /home/node
USER node
COPY ton-q-server /home/node/
RUN npm ci && npm run tsc && npm ci --production
EXPOSE 4000
ENTRYPOINT ["node", "index.js"]
