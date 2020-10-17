#!/bin/sh

# Install the latest version of Nuxt
yarn create nuxt-app nuxt-project
cp -Rp nuxt-project/. client
rm -Rf nuxt-project/

# Install project
make install