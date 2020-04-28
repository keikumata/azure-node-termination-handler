module dev.azure.com/msazure/CloudNativeCompute/aks-operator

go 1.14

require (
	github.com/Azure/go-autorest/autorest/azure/auth v0.4.2 // indirect
	github.com/Azure/go-autorest/autorest/to v0.3.0 // indirect
	github.com/Azure/go-autorest/autorest/validation v0.2.0 // indirect
	github.com/golangci/golangci-lint v1.24.0
	github.com/goreleaser/goreleaser v0.128.0
	github.com/jstemmer/go-junit-report v0.9.1
	github.com/matm/gocov-html v0.0.0-20191111163307-9ee104d84c82 // indirect
	github.com/t-yuki/gocover-cobertura v0.0.0-20180217150009-aaee18c8195c // indirect
	sigs.k8s.io/controller-tools v0.2.7
	sigs.k8s.io/kustomize/kustomize/v3 v3.5.4
)

replace github.com/Azure/go-autorest => github.com/Azure/go-autorest v14.0.0+incompatible
