CURDIR=$(shell pwd)

.PHONY: build
build:
	cd $(CURDIR); go mod tidy
	cd $(CURDIR); go build -o kubearmor-log-client main.go

.PHONY: run
run: $(CURDIR)/kubearmor-log-client
	cd $(CURDIR); sudo rm -f /tmp/kubearmor-message /tmp/kubearmor-log
	cd $(CURDIR); ./kubearmor-log-client -msg=/tmp/kubearmor-message -log=/tmp/kubearmor-log

.PHONY: build-image
build-image:
	cd $(CURDIR); docker build -t kubearmor/kubearmor-log-client:latest .

.PHONY: push-image
push-image:
	cd $(CURDIR); docker push kubearmor/kubearmor-log-client:latest

.PHONY: clean
clean:
	cd $(CURDIR); sudo rm -f kubearmor-log-client /tmp/kubearmor-message /tmp/kubearmor-log
	#cd $(CURDIR); find . -name go.sum | xargs -I {} rm -f {}
