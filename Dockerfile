# Image de CI Salesforce DX pour GitLab CI.
# La version du Salesforce CLI est pilotée par l'argument SF_CLI_VERSION,
# fourni par le workflow de publication (voir .github/workflows/docker-upload.yml).
ARG NODE_VERSION=22
FROM node:${NODE_VERSION}-slim

ARG SF_CLI_VERSION=2.150.6
ARG SGD_VERSION=6.45.1
ARG FLOW_LINTER_VERSION=1.3.0
ARG PLUGIN_COMMUNITY_VERSION=4.0.6

LABEL org.opencontainers.image.title="sfdx-cli-gitlab" \
      org.opencontainers.image.description="Salesforce CLI ${SF_CLI_VERSION} + plugins pour GitLab CI" \
      org.opencontainers.image.source="https://github.com/Faymany/sfdx-cli-gitlab"

# Désactive l'auto-update et la télémétrie du CLI : indispensable en CI
# pour des builds reproductibles et sans appel réseau superflu.
ENV SF_DISABLE_AUTOUPDATE=true \
    SF_AUTOUPDATE_DISABLE=true \
    SF_DISABLE_TELEMETRY=true \
    SF_HIDE_RELEASE_NOTES=true \
    SF_HIDE_RELEASE_NOTES_FOOTER=true \
    SHELL=/bin/bash

# Installation des dépendances système nécessaires
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    findutils \
    bash \
    unzip \
    curl \
    wget \
    ca-certificates \
    openjdk-17-jre-headless \
    openssh-client \
    perl \
    jq \
    python3 \
 && rm -rf /var/lib/apt/lists/*

# Mise à jour de npm vers la dernière version
RUN npm install -g npm@latest

# Installation du Salesforce CLI (version épinglée) et des plugins requis
RUN npm install -g @salesforce/cli@${SF_CLI_VERSION} \
 && echo y | sf plugins install sfdx-git-delta@${SGD_VERSION} \
 && echo y | sf plugins install @corekraft/flow-linter@${FLOW_LINTER_VERSION} \
 && echo y | sf plugins install @salesforce/plugin-community@${PLUGIN_COMMUNITY_VERSION} \
 && npm cache clean --force

# Vérification : l'image doit exposer le CLI et ses plugins
RUN sf version --verbose && sf plugins --core
