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

.PHONY: gofmt
gofmt:
	cd $(CURDIR); gofmt -s -d $(shell find . -type f -name '*.go' -print)

.PHONY: golint
golint:
ifeq (, $(shell which golint))
	@{ \
	set -e ;\
	GOLINT_TMP_DIR=$$(mktemp -d) ;\
	cd $$GOLINT_TMP_DIR ;\
	go mod init tmp ;\
	go get -u golang.org/x/lint/golint ;\
	rm -rf $$GOLINT_TMP_DIR ;\
	}
endif
	cd $(CURDIR); golint ./...

.PHONY: gosec
gosec:
ifeq (, $(shell which gosec))
	@{ \
	set -e ;\
	GOSEC_TMP_DIR=$$(mktemp -d) ;\
	cd $$GOSEC_TMP_DIR ;\
	go mod init tmp ;\
	go get -u github.com/securego/gosec/v2/cmd/gosec ;\
	rm -rf $$GOSEC_TMP_DIR ;\
	}
endif
	cd $(CURDIR); gosec ./...
