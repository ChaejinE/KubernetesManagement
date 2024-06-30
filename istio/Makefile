NAMESPACE ?= default

# Only Using Istio docs
setup-istio:
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

# Using Seperated Components

setup-istio-operator:
	git submodule update --init

install-istio-operator: setup-istio-operator
	helm upgrade istio-operator istio/manifests/charts/istio-operator \
		--set watchedNamespaces="istio-system\,default" \
		-n istio-system --create-namespace \
		--install

uninstall-istio-operator: setup-istio-operator
	helm uninstall istio-operator -n istio-system

apply-istio-operator:
	kubectl apply -f istio-operator.yaml

delete-istio-operator:
	kubectl delete -f istio-operator.yaml

setup-kiali:
	helm repo add kiali https://kiali.org/helm-charts
	helm repo update kiali

install-kiali-operator: setup-kiali
	helm upgrade kiali-operator kiali/kiali-operator \
		-n kiali-operator --create-namespace \
		--wait --install

uninstall-kiali-operator: setup-kiali
	helm uninstall kiali-operator -n kiali-operator

apply-kiali:
	kubectl apply -f kiali.yaml

delete-kiali:
	kubectl delete -f kiali.yaml

install-certmanager:
	kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.6.3/cert-manager.yaml

install-jaeger-operator: install-certmanager
	kubectl create namespace observability || true
	kubectl apply -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.57.0/jaeger-operator.yaml -n observability

uninstall-jaeger-operator:
	kubectl delete -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.57.0/jaeger-operator.yaml -n observability

apply-jaeger:
	kubectl apply -f jaeger.yaml

delete-jaeger:
	kubectl delete -f jaeger.yaml

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

ANNO_KEY ?= sidecar.jaegertracing.io/inject
ANNO_VALUE ?= true
inject-annotaion:
	echo "Before"
	kubectl describe ns ${NAMESPACE}

	kubectl annotate ns ${NAMESPACE} ${ANNO_KEY}=${ANNO_VALUE} --overwrite

	echo "After"
	kubectl describe ns ${NAMESPACE}

extract-annotaion:
	echo "Before"
	kubectl describe ns ${NAMESPACE}

	kubectl annotate ns ${NAMESPACE} ${ANNO_KEY}-

	echo "After"
	kubectl describe ns ${NAMESPACE}

install: install-istio-operator apply-istio-operator install-kiali-operator apply-kiali install-jaeger-operator apply-jaeger inject-label install-grafana install-prometheus
uninstall: delete-istio-operator uninstall-istio-operator delete-kiali uninstall-kiali-operator delete-jaeger uninstall-jaeger-operator extract-label uninstall-grafana uninstall-prometheus
