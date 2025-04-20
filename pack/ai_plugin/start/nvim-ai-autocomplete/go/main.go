package main

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
)

type RequestData struct {
	Code string `json:"code"`
}
type AIResponse struct {
	Suggestion string `json:"suggestion"`
}

func generateAISuggestion(code string) string {
	return code
}
func handler(w http.ResponseWriter, r *http.Request) {
	body, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, "Cannot read request", http.StatusBadRequest)
		return
	}
	var requestData RequestData
	json.Unmarshal(body, &requestData)

    println(requestData.Code)
	response := AIResponse{Suggestion: generateAISuggestion(requestData.Code)}
	json.NewEncoder(w).Encode(response)
}

func main() {
	http.HandleFunc("/ai-suggest", handler)
	fmt.Println("GO AI SERVER RUNNING ON PORT 8081")

	log.Fatal(http.ListenAndServe(":8081", nil))
}
