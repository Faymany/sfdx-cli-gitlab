FROM node:23-slim
# Installation des dépendances système nécessaires
RUN apt-get update && apt-get install -y \
    git \
    findutils \
    bash \
    unzip \
    curl \
    wget \
    openjdk-17-jre-headless \
    openssh-client \
    perl \
    jq \
    python3 \
 && rm -rf /var/lib/apt/lists/*

# Mise à jour de npm vers la dernière version
RUN npm install -g npm@latest

# Installation du Salesforce CLI et des plugins requis
# RUN npm install -g @salesforce/cli \
#  && npm install -g @salesforce/plugin-community \
#  && echo y | sf plugins install sfdx-git-delta \
#  && echo y | sf plugins install @corekraft/flow-linter \
#  && echo y | sf plugins install community
