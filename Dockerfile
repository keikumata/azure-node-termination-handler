FROM k8s.gcr.io/node-problem-detector:v0.8.1

# Download the Azure Node Termination Handler binary
ADD ./dist/azure-node-termination-handler_linux_amd64/azure-node-termination-handler /usr/local/bin/azure-node-termination-handler
