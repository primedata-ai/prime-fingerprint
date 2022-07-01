FROM node:14.1-alpine AS build

ARG SERVE_VERSION=13.0.2

WORKDIR /build

COPY package.json .

RUN npm install

COPY . .

RUN npm run build

FROM node:14.1-alpine

ARG POWEHI_HOME=/public/tracker
ENV PORT=8181

# Install serve library with version (default to 13.0.2), reference from https://www.npmjs.com/package/serve/v/13.0.2
RUN npm install -g serve@${SERVE_VERSION}

RUN mkdir -p ${POWEHI_HOME}

COPY --from=build /build ${POWEHI_HOME}

EXPOSE ${PORT}

CMD serve -s /public -p ${PORT}
