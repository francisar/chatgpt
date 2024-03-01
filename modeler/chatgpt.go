package modeler

import (
	"context"
	"fmt"
	ernie "github.com/anhao/go-ernie"
	"github.com/sashabaranov/go-openai"
	"os"
	"strings"
)


var ernieClient *ernie.Client

func init() {
	ernieClient = ernie.NewDefaultClient(os.Getenv("BAIDU_API_KEY"), os.Getenv("BAIDU_SECRET_KEY"))
}

func ernieTalk(promt string) (string, error) {
	completion, err := ernieClient.CreateErnieBot4ChatCompletion(context.Background(), ernie.ErnieBot4Request{
		Messages: []ernie.ChatCompletionMessage{
			{
				Role:    ernie.MessageRoleUser,
				Content: promt,
			},
		},
	})
	if err != nil {
		fmt.Printf("ernie bot error: %v\n", err)
		return "", err
	}
	return completion.Result, nil
}
func gpt(promt string)  (string, error)  {
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

func Textcompletion(promt string) (string, error) {
	return ernieTalk(promt)
}
