package modeler

import (
	"context"
	"fmt"
	"github.com/sashabaranov/go-openai"
	"os"
	"strings"
)

func Textcompletion(promt string) (string, error) {
	token := os.Getenv("GPT_TOKEN")
	fmt.Println(token)
	c := openai.NewClient(token)
	ctx := context.Background()
	req := openai.ChatCompletionRequest{
		Model:     openai.GPT3Dot5Turbo0125,
		MaxTokens: 16385,
		Messages:    []openai.ChatCompletionMessage{
			{
				Role:    openai.ChatMessageRoleSystem,
				Content: promt,
			},
		},
	}
	resp, err := c.CreateChatCompletion(ctx, req)
	if err != nil {
		return "", err
	}
	var builder strings.Builder
	builder.Grow(16385 )
	for _,choices := range resp.Choices {
		builder.WriteString(choices.Message.Content)
	}
	return builder.String(), nil
}
