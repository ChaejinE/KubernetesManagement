#!/bin/bash

helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

# For CRDs
helm upgrade istio-base istio/base \
    -n istio-system --create-namespace \
    --set defaultRevision=default \
    --install --wait

# Istiod for istio control plane
helm upgrade istiod istio/istiod -n istio-system \
    --wait --install

# IstioIngressGateway
helm upgrade istio-ingressgateway istio/gateway -n istio-ingress --create-namespace \
    --install
