package handler

import (
	"fmt"
	"github.com/francisar/chatgpt/modeler"
	"github.com/silenceper/wechat/v2/officialaccount/message"
)

func OffAccMessageHandler(msg *message.MixMessage) *message.Reply {

	// 回复消息：演示回复用户发送的消息

	replyText, err := modeler.Textcompletion(msg.Content)
	text := message.NewText(replyText)
	replyMsg :=  message.Reply{
		MsgType: message.MsgTypeText,
		MsgData: text,
	}
	if err != nil {
		fmt.Println(err)
	}
	replyMsg.MsgData = &replyText
	return &replyMsg
}
