package ginserve

import (
	"fmt"
	"github.com/francisar/chatgpt/handler"
	"github.com/gin-gonic/gin"
	"github.com/silenceper/wechat/v2"
	"github.com/silenceper/wechat/v2/cache"
	offConfig "github.com/silenceper/wechat/v2/officialaccount/config"
)

func OffServe(c *gin.Context)  {
	wc := wechat.NewWechat()
	memory := cache.NewMemory()
	cfg := &offConfig.Config{
		AppID:     "xxx",
		AppSecret: "xxx",
		Token:     "xxx",
		// EncodingAESKey: "xxxx",
		Cache: memory,
	}
	officialAccount := wc.GetOfficialAccount(cfg)
	server := officialAccount.GetServer(c.Request, c.Writer)
	// 设置接收消息的处理方法
	server.SetMessageHandler(handler.OffAccMessageHandler)
	// 处理消息接收以及回复
	err := server.Serve()
	if err != nil {
		fmt.Println(err)
		return
	}
	err = server.Send()
	if err != nil {
		fmt.Println(err)
		return
	}
}
