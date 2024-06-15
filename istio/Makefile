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

install-istioIngressGateway:
	echo "Install istioIngressGateway"
	helm upgrade istio-ingressgateway istio/manifests/charts/gateways/istio-ingress \
		-n istio-system --create-namespace \
    	--install

uninstall-istioIngressGateway:
	echo "Uninstall istioIngressGateway"
	helm uninstall istio-ingress -n istio-system

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
	helm upgrade \
		--set cr.create=true \
		--set cr.namespace=istio-system \
		--set cr.spec.auth.strategy="anonymous" \
		--set cr.spec.external_services.prometheus.url="http://prometheus-server.istio-system/" \
		--set cr.spec.external_services.grafana.in_cluster_url="http://grafana.istio-system/" \
		--set cr.spec.external_services.tracing.use_grpc=true \
		--set cr.spec.external_services.tracing.in_cluster_url="http://tracing.istio-system/jaeger" \
		-n kiali-operator --create-namespace \
		kiali-operator kiali/kiali-operator \
		--wait --install

uninstall-kiali: setup-kiali
	helm uninstall kiali-operator -n kiali-operator

setup-monitoring:
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update grafana prometheus-community

install-grafana: setup-monitoring
	helm upgrade grafana grafana/grafana \
		-n istio-system --create-namespace \
		--install --wait

uninstall-grafana: setup-monitoring
	helm uninstall grafana -n istio-system

install-prometheus: setup-monitoring
	helm upgrade prometheus prometheus-community/prometheus \
		-n istio-system --create-namespace \
		--install

uninstall-prometheus: setup-monitoring
	helm uninstall prometheus -n istio-system

install-jaegertracing: setup-monitoring
	kubectl apply -n istio-system -f jaeger

uninstall-jaegertracing: setup-monitoring
	kubectl delete -n istio-system -f jaeger

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

install: setup install-CRDs install-istiod install-istioIngressGateway install-istioEngressGateway install-addons inject-label
uninstall: setup uninstall-CRDs uninstall-istiod uninstall-istioIngressGateway uninstall-istioEngressGateway uninstall-addons extract-label
