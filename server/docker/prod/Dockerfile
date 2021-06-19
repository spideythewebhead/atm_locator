FROM node:15.14.0-alpine3.13

USER node

RUN mkdir -p /home/node/server && \
  mkdir ~/.npm-global && npm config set prefix ~/.npm-global && \
  export PATH=~/.npm-global/bin:$PATH && \
  npm install -g yarn

WORKDIR /home/node/server

COPY ./yarn.lock ./package.json ./

RUN yarn install