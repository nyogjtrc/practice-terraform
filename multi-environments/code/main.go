package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

// Response of API
type Response struct {
	Message string `json:"message"`
	At      string `json:"at"`
}

func handleRequest(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	resp := Response{
		Message: "Hello World!",
		At:      time.Now().Format(time.RFC3339),
	}
	name, ok := req.QueryStringParameters["name"]
	if ok {
		resp.Message = fmt.Sprintf("Hello, %s!\n", name)
	}

	body, _ := json.Marshal(resp)
	res := events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Headers:    map[string]string{"Content-Type": "text/json; charset=utf-8"},
		Body:       string(body),
	}
	return res, nil
}

func main() {
	lambda.Start(handleRequest)
}
