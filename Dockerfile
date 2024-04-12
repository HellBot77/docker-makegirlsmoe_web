FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/makegirlsmoe/makegirlsmoe_web.git && \
    cd makegirlsmoe_web && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine as build

WORKDIR /makegirlsmoe_web
COPY --from=base /git/makegirlsmoe_web .
RUN npm install && \
    sed -i 's/var debug = false;/var debug = true;/' src/Config.js && \
    npm run build

FROM lipanski/docker-static-website

COPY --from=build /makegirlsmoe_web/build .
