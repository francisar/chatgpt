package handler

import (
	"fmt"
	"github.com/francisar/chatgpt/modeler"
	"github.com/silenceper/wechat/v2/officialaccount/message"
)

func OffAccMessageHandler(msg *message.MixMessage) *message.Reply {

	// 回复消息：演示回复用户发送的消息
	text := message.NewText(msg.Content)
	replyText, err := modeler.Textcompletion(string(text.Content))
	replyMsg :=  message.Reply{
		MsgType: message.MsgTypeText,
		MsgData: "我需要休息一下，等等再聊",
	}
	if err != nil {
		fmt.Println(err)
	}
	replyMsg.MsgData = replyText
	return &replyMsg
}
