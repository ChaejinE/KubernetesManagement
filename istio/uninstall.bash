#!/bin/bash

# For CRDs
helm uninstall istio-base -n istio-system

# Istiod for istio control plane
helm uninstall istiod -n istio-system

# IstioIngressGateway
helm uninstall istio-ingressgateway -n istio-ingress
