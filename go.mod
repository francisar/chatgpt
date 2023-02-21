module github.com/francisar/chatgpt

go 1.16

require (
	github.com/francisar/base-util v0.0.8 // indirect
	github.com/francisar/component v0.0.0-20230216081257-fe626fdc39fe // indirect
	github.com/gin-gonic/gin v1.8.2
	github.com/gogo/protobuf v1.3.2
	github.com/golang/protobuf v1.5.2
	github.com/grpc-ecosystem/grpc-gateway v1.16.0
	github.com/grpc-kit/pkg v0.2.3
	github.com/sashabaranov/go-gpt3 v1.1.0
	github.com/silenceper/wechat/v2 v2.1.4
	github.com/sirupsen/logrus v1.9.0
	github.com/spf13/pflag v1.0.5
	github.com/spf13/viper v1.10.1
	google.golang.org/api v0.63.0
	google.golang.org/genproto v0.0.0-20211208223120-3a66f561d7aa
	google.golang.org/grpc v1.43.0
)

replace google.golang.org/grpc => google.golang.org/grpc v1.38.0
