NAMESPACE ?= default

setup:
	helm repo add istio https://istio-release.storage.googleapis.com/charts
	helm repo update istio
	git submodule update --init

install-CRDs:
	echo "Install Istio CRDs"
	helm upgrade istio-base istio/base \
		--set defaultRevision=default \
		-n istio-system --create-namespace \
		--install --wait

uninstall-CRDs:
	echo "Uninstall istio CRDs"
	helm uninstall istio-base -n istio-system

install-istiod:
	echo "Install istiod"
	helm upgrade istiod istio/istiod \
    	-n istio-system --create-namespace \
		--install --wait

uninstall-istiod:
	echo "Uninstall istiod"
	helm uninstall istiod -n istio-system

install-istio-operator:
	helm upgrade istio-operator istio/manifests/charts/istio-operator \
		--set watchedNamespaces="istio-system\,default" \
		-n istio-system --create-namespace \
		--install

uninstall-istio-operator:
	helm uninstall istio-operator -n istio-system

install-istioIngressGateway:
	echo "Install istioIngressGateway"
	helm upgrade istio-ingressgateway istio/manifests/charts/gateways/istio-ingress \
		-n istio-system --create-namespace \
    	--install

uninstall-istioIngressGateway:
	echo "Uninstall istioIngressGateway"
	helm uninstall istio-ingressgateway -n istio-system

install-istioEgressGateway:
	echo "Install istioEgressGateway"
	helm upgrade istio-egressgateway istio/manifests/charts/gateways/istio-egress \
		-n istio-system --create-namespace \
    	--install

uninstall-istioEgressGateway:
	echo "Uninstall istioEgressGateway"
	helm uninstall istio-egressgateway -n istio-system

install-addons:
	kubectl apply -f istio/samples/addons/grafana.yaml -n istio-system
	kubectl apply -f istio/samples/addons/prometheus.yaml -n istio-system
	kubectl apply -f istio/samples/addons/jaeger.yaml -n istio-system
	kubectl apply -f istio/samples/addons/kiali.yaml -n istio-system

uninstall-addons:
	kubectl delete -f istio/samples/addons/grafana.yaml -n istio-system
	kubectl delete -f istio/samples/addons/prometheus.yaml -n istio-system
	kubectl delete -f istio/samples/addons/jaeger.yaml -n istio-system
	kubectl delete -f istio/samples/addons/kiali.yaml -n istio-system

setup-kiali:
	helm repo add kiali https://kiali.org/helm-charts
	helm repo update kiali

install-kiali: setup-kiali
	helm upgrade kiali-operator kiali/kiali-operator \
		-n kiali-operator --create-namespace \
		--wait --install

uninstall-kiali: setup-kiali
	helm uninstall kiali-operator -n kiali-operator

setup-monitoring:
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update grafana prometheus-community

install-grafana:
	VERSION=1.22; \
	PROMETHEUS_ADDON=https://raw.githubusercontent.com/istio/istio/release-$${VERSION}/samples/addons/grafana.yaml; \
	kubectl apply -f $${PROMETHEUS_ADDON} -n istio-system

uninstall-grafana:
	VERSION=1.22; \
	PROMETHEUS_ADDON=https://raw.githubusercontent.com/istio/istio/release-$${VERSION}/samples/addons/grafana.yaml; \
	kubectl delete -f $${PROMETHEUS_ADDON} -n istio-system

install-prometheus:
	VERSION=1.22; \
	PROMETHEUS_ADDON=https://raw.githubusercontent.com/istio/istio/release-$${VERSION}/samples/addons/prometheus.yaml; \
	kubectl apply -f $${PROMETHEUS_ADDON} -n istio-system

uninstall-prometheus:
	VERSION=1.22; \
	PROMETHEUS_ADDON=https://raw.githubusercontent.com/istio/istio/release-$${VERSION}/samples/addons/prometheus.yaml; \
	kubectl delete -f $${PROMETHEUS_ADDON} -n istio-system

install-jaeger:
	VERSION=1.22; \
	PROMETHEUS_ADDON=https://raw.githubusercontent.com/istio/istio/release-$${VERSION}/samples/addons/jaeger.yaml; \
	kubectl apply -f $${PROMETHEUS_ADDON} -n istio-system

uninstall-jaeger:
	VERSION=1.22; \
	PROMETHEUS_ADDON=https://raw.githubusercontent.com/istio/istio/release-$${VERSION}/samples/addons/jaeger.yaml; \
	kubectl delete -f $${PROMETHEUS_ADDON} -n istio-system

LABEL_KEY ?= istio-injection
LABEL_VALUE ?= enabled
inject-label:
	echo "Before"
	kubectl describe ns ${NAMESPACE}

	kubectl label ns ${NAMESPACE} ${LABEL_KEY}=${LABEL_VALUE} --overwrite

	echo "After"
	kubectl describe ns ${NAMESPACE}

extract-label:
	echo "Before"
	kubectl describe ns ${NAMESPACE}

	kubectl label ns ${NAMESPACE} ${LABEL_KEY}-

	echo "After"
	kubectl describe ns ${NAMESPACE}

install: install-istio-operator install-addons inject-label
uninstall: uninstall-istio-operator uninstall-addons extract-label
