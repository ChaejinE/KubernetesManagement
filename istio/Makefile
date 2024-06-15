setup:
	helm repo add istio https://istio-release.storage.googleapis.com/charts
	helm repo update

install-CRDs:
	echo "Install Istio CRDs"
	helm upgrade istio-base istio/base \
		-n istio-system --create-namespace \
		--set defaultRevision=default \
		--install --wait

uninstall-CRDs:
	echo "Uninstall istio CRDs"
	helm uninstall istio-base -n istio-system

install-istiod:
	echo "Install istiod"
	helm upgrade istiod istio/istiod -n istio-system \
    	--wait --install

uninstall-istiod:
	echo "Uninstall istiod"
	helm uninstall istiod -n istio-system

install-istioGateway:
	echo "Install IstioIngressGateway"
	helm upgrade istio-ingressgateway istio/gateway -n istio-ingress --create-namespace \
    	--install

uninstall-istioGateway:
	echo "Uninstall IstioIngressGateway"
	helm uninstall istio-ingressgateway -n istio-ingress

install: setup install-CRDs install-istiod install-istioGateway

uninstall: setup uninstall-CRDs uninstall-istiod uninstall-istioGateway
