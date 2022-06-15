

start:
	./start.sh

stop:
	kind delete cluster --name istio-mtls
