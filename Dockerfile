# syntax=docker/dockerfile:1

FROM node:24-bookworm-slim AS base

ENV FORCE_COLOR=0
WORKDIR /opt/docusaurus

FROM base AS prod

COPY package*.json ./
RUN npm ci

COPY . .

ARG DOCUSAURUS_URL=https://docs.llaun.ch
ARG DOCUSAURUS_REDIR=llaun.ch

ENV DOCUSAURUS_URL=${DOCUSAURUS_URL}
ENV DOCUSAURUS_REDIR=${DOCUSAURUS_REDIR}

RUN npm run build

FROM prod AS serve

EXPOSE 3000

CMD ["npm", "run", "serve", "--", "--host", "0.0.0.0", "--no-open"]
