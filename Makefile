# Image URL to use all building/pushing image targets
IMG ?= controller:latest
# Produce CRDs that work back to Kubernetes 1.11 (no version conversion)
CRD_OPTIONS ?= "crd:trivialVersions=true"

# Directories
TOOLS_DIR := $(PWD)/hack/tools
TOOLS_BIN_DIR := $(TOOLS_DIR)/bin
BIN_DIR := bin

# Binaries
GOLANGCI_LINT := $(TOOLS_BIN_DIR)/golangci-lint
GORELEASER := $(TOOLS_BIN_DIR)/goreleaser
KUSTOMIZE := $(TOOLS_BIN_DIR)/kustomize
GO_JUNIT_REPORT := $(TOOLS_BIN_DIR)/go-junit-report
GOCOV := $(TOOLS_BIN_DIR)/gocov
GOCOV_HTML := $(TOOLS_BIN_DIR)/gocov-html
GOCOVER_COBERTURA := $(TOOLS_BIN_DIR)/gocover-cobertura

all: run

# Run tests
test: coverage-bin lint manifests
	mkdir -p coverage
	go test ./... -race -coverprofile cover.out -covermode atomic -v 2>&1 | $(GO_JUNIT_REPORT) --set-exit-code > report.xml; FAILED=$$?;\
	$(GOCOVER_COBERTURA) < cover.out > summary.xml;\
	$(GOCOV) convert cover.out | $(GOCOV_HTML) > coverage/index.html;\
	exit $$FAILED

# Binaries

restore: $(GOLANGCI_LINT) $(GORELEASER) $(KUSTOMIZE) coverage-bin
	go mod download

coverage-bin: $(GO_JUNIT_REPORT) $(GOCOV) $(GOCOV_HTML) $(GOCOVER_COBERTURA)

$(GOLANGCI_LINT): $(TOOLS_DIR)/go.mod # Build golangci-lint from tools folder.
	cd $(TOOLS_DIR); go build -tags=tools -o $(BIN_DIR)/golangci-lint github.com/golangci/golangci-lint/cmd/golangci-lint

$(GORELEASER): $(TOOLS_DIR)/go.mod # Build goreleaser from tools folder.
	cd $(TOOLS_DIR); go build -tags=tools -o $(BIN_DIR)/goreleaser github.com/goreleaser/goreleaser

$(KUSTOMIZE): $(TOOLS_DIR)/go.mod # Build kustomize from tools folder.
	cd $(TOOLS_DIR); go build -tags=tools -o $(BIN_DIR)/kustomize sigs.k8s.io/kustomize/kustomize/v3

$(GO_JUNIT_REPORT): $(TOOLS_DIR)/go.mod # Build go-junit-report from tools folder.
	cd $(TOOLS_DIR); go build -tags=tools -o $(BIN_DIR)/go-junit-report github.com/jstemmer/go-junit-report

$(GOCOV): $(TOOLS_DIR)/go.mod # Build gocov from tools folder.
	cd $(TOOLS_DIR); go build -tags=tools -o $(BIN_DIR)/gocov github.com/axw/gocov/gocov

$(GOCOV_HTML): $(TOOLS_DIR)/go.mod # Build gocov-html from tools folder.
	cd $(TOOLS_DIR); go build -tags=tools -o $(BIN_DIR)/gocov-html github.com/matm/gocov-html

$(GOCOVER_COBERTURA): $(TOOLS_DIR)/go.mod # Build cover-cobertura from tools folder.
	cd $(TOOLS_DIR); go build -tags=tools -o $(BIN_DIR)/gocover-cobertura github.com/t-yuki/gocover-cobertura

# Run against the configured Kubernetes cluster in ~/.kube/config
run: lint manifests
	go run ./main.go

# Linting
.PHONY: lint lint-full
lint: $(GOLANGCI_LINT) ## Lint codebase
	$(GOLANGCI_LINT) run -v

lint-full: $(GOLANGCI_LINT) ## Run slower linters to detect possible issues
	$(GOLANGCI_LINT) run -v --fast=false

# Build the docker image
docker-build: lint manifests
	docker build . -t ${IMG}

# Push the docker image
docker-push:
	docker push ${IMG}

# Packaging

package: $(GORELEASER)
	$(GORELEASER) --snapshot --skip-publish --rm-dist
