package azure

import (
	"strings"
)

// ConvertNodeName converts the node name received from the IMDS endpoint into the actual Azure VMSS node name
func ConvertNodeName(imdsNodeName string) string {
	// aks-agentpool-32993996-vmss_1 => aks-agentpool-32993996-vmss000001
	arr := strings.Split(imdsNodeName, "-")
	suffix := arr[len(arr)-1] // ex: vmss_1

	vmssArr := strings.Split(suffix, "_")
	arr[len(arr)-1] = strings.Replace(suffix, "_", createZeroes(6-len(vmssArr[1])), 1)

	return strings.Join(arr, "-")
}

func createZeroes(n int) string {
	res := ""
	for i := 0; i < n; i++ {
		res += "0"
	}
	return res
}
