package main

import (
	"fmt"
	"github.com/silenceper/wechat/v2/officialaccount/message"
)

func main()  {
	msgType := message.MsgTypeText
	switch msgType {
	case message.MsgTypeText:
	case message.MsgTypeImage:
	case message.MsgTypeVoice:
	case message.MsgTypeVideo:
	case message.MsgTypeMusic:
	case message.MsgTypeNews:
	case message.MsgTypeTransfer:
	default:
		err := message.ErrUnsupportReply
		fmt.Println(err)
		return
	}

}
