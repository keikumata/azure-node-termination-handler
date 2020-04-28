package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"

	"github.com/keikumata/azure-node-termination-handler/azure/events"
)

func main() {
	client := &http.Client{}

	req, _ := http.NewRequest("GET", "http://169.254.169.254/metadata/scheduledevents", nil)
	req.Header.Add("Metadata", "True")

	q := req.URL.Query()
	q.Add("format", "json")
	q.Add("api-version", "2019-01-01")
	req.URL.RawQuery = q.Encode()

	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Errored when sending request to the server")
		return
	}

	respBody, _ := ioutil.ReadAll(resp.Body)
	resp.Body.Close()

	// Ignore any unsuccessful requests
	if resp.StatusCode != 200 {
		os.Exit(0)
	}

	if resp.StatusCode == 200 {
		var scheduledEventsResp events.ScheduledEventsResponse
		err := json.Unmarshal(respBody, &scheduledEventsResp)
		// Ignore marshaling error
		if err != nil {
			os.Exit(0)
		}
		for _, v := range scheduledEventsResp.Events {
			name := os.Getenv("NODE_NAME")
			if *v.EventType == "Terminate" && stringInSlice(name, *v.Resources) {
				os.Exit(1)
			}
		}
	}
}

func stringInSlice(a string, list []string) bool {
	for _, b := range list {
		if b == a {
			return true
		}
	}
	return false
}