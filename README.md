# azure-node-termination-handler
A termination handler for Azure that handles termination notifications for Azure VMs through the Azure Metadata Service

This repo leverages the [node-problem-detector](https://github.com/kubernetes/node-problem-detector), which is a pluggable service to detect various issues. The main binary will hit the [IMDS scheduled events endpoint](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-terminate-notification) to determine whether there is a termination event for the VM, and is embedded into NPD as a custom plugin. NPD will take this and display them as Kubernetes conditions / events.

Here is an example of the node termination event produced by this NPD plugin:
```
{
    "lastHeartbeatTime": "2020-04-28T04:00:20Z",
    "lastTransitionTime": "2020-04-28T04:00:20Z",
    "message": "IMDS has a scheduled event for termination",
    "reason": "HasNodeTerminationEvent",
    "status": "True",
    "type": "NodeTermination"
}
```

What's missing currently is the ability to cordon and drain nodes after the plugin detects a termination event. I plan to either create a simple K8s controller to handle this or embed this in the CAPI project, but it should be straight forward as it just needs to act on the node condition set by this NPD plugin.
