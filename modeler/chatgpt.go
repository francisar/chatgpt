package modeler

import (
	"context"
	"fmt"
	"github.com/sashabaranov/go-gpt3"
	"os"
	"strings"
)

func Textcompletion(promt string) (string, error) {
	token := os.Getenv("GPT_TOKEN")
	fmt.Println(token)
	c := gogpt.NewClient(token)
	ctx := context.Background()
	req := gogpt.CompletionRequest{
		Model:     gogpt.GPT3TextDavinci003,
		MaxTokens: 2048,
		Prompt:    promt,
	}
	resp, err := c.CreateCompletion(ctx, req)
	if err != nil {
		return "", err
	}
	var builder strings.Builder
	builder.Grow(2048 )
	for _,choices := range resp.Choices {
		builder.WriteString(choices.Text)
	}
	return builder.String(), nil
}
