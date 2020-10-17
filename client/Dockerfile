# https://docs.docker.com/develop/develop-images/multistage-build/#stop-at-a-specific-build-stage
# https://docs.docker.com/compose/compose-file/#target


# https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG NODE_VERSION=13.8

# "development" stage
FROM node:${NODE_VERSION}-alpine AS api_platform_client

ENV HOST 0.0.0.0

RUN mkdir -p /usr/src/client
WORKDIR /usr/src/client

RUN apk add --update --no-cache python make g++

# prevent the reinstallation of node modules at every changes in the source code
COPY package.json yarn.lock ./
RUN yarn install

COPY . ./

CMD yarn dev
