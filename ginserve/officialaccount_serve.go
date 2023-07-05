package ginserve

import (
	"fmt"
	"github.com/francisar/chatgpt/handler"
	"github.com/gin-gonic/gin"
	"github.com/silenceper/wechat/v2"
	"github.com/silenceper/wechat/v2/cache"
	offConfig "github.com/silenceper/wechat/v2/officialaccount/config"
	"github.com/spf13/viper"
	"net/http"
)

func OffServe(c *gin.Context)  {
	wc := wechat.NewWechat()
	memory := cache.NewMemory()
	appId := viper.GetString("WECHAT_APPID")
	appSecret := viper.GetString("WECHAT_APPSECRET")
	token := viper.GetString("WECHAT_TOKEN")
	encodingAESKey := viper.GetString("WECHAT_ENCODINGAESKEY")
	fmt.Println(appId)
	cfg := &offConfig.Config{
		AppID:     appId,
		AppSecret: appSecret,
		Token:     token,
		EncodingAESKey: encodingAESKey,
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



func HealthServe(c *gin.Context)  {
	c.String(http.StatusOK, "OK")
}
