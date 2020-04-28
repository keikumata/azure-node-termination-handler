package azure

type ScheduledEventsResponse struct {
	DocumentIncarnation int              `json:"DocumentIncarnation"`
	Events              []ScheduledEvent `json:"Events"`
}

type ScheduledEvent struct {
	EventID      *string   `json:"EventId,omitempty"`
	EventType    *string   `json:"EventType,omitempty"`
	ResourceType *string   `json:"ResourceType,omitempty"`
	Resources    *[]string `json:"Resources,omitempty"`
	EventStatus  *string   `json:"EventStatus,omitempty"`
	NotBefore    *string   `json:"NotBefore,omitempty"`
}
