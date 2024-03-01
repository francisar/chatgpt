package main

import (
	"context"
	"fmt"
	ernie "github.com/anhao/go-ernie"
)

func main() {

	client := ernie.NewDefaultClient("API KEY", "Securet EKY")
	completion, err := client.CreateErnieBot4ChatCompletion(context.Background(), ernie.ErnieBot4Request{
		Messages: []ernie.ChatCompletionMessage{
			{
				Role:    ernie.MessageRoleUser,
				Content: "你好呀",
			},
		},
	})
	if err != nil {
		fmt.Printf("ernie bot error: %v\n", err)
		return
	}
	fmt.Println(completion)
}