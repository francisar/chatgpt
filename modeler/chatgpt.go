package modeler

import (
	"context"
	"github.com/sashabaranov/go-gpt3"
	"strings"
)

func Textcompletion(promt string) (string, error) {
	c := gogpt.NewClient("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")
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
