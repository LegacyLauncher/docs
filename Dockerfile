# syntax=docker/dockerfile:1

# See: https://docusaurus.community/knowledge/deployment/docker/

FROM node:lts AS base
ENV FORCE_COLOR=0
RUN corepack enable
WORKDIR /opt/docusaurus

FROM base AS prod
WORKDIR /opt/docusaurus
COPY . /opt/docusaurus/
RUN npm ci
RUN npm run build

FROM prod AS serve
EXPOSE 3000
CMD ["npm", "run", "serve", "--", "--host", "0.0.0.0", "--no-open"]
