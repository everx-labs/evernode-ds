FROM node:18-buster
WORKDIR /home/node
USER node
COPY . /home/node/
RUN npm install
ENTRYPOINT ["npm", "run", "msig-wallet"]
