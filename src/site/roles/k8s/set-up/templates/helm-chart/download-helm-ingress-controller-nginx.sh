#!/bin/bash

set -xeu

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx \
    || true

helm pull ingress-nginx/ingress-nginx
