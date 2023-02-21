package main

import (
	"fmt"
	"github.com/francisar/chatgpt/ginserve"
	"github.com/gin-gonic/gin"
	"os"
)

func main()  {
	r := gin.Default()
	// 传入request和responseWriter
	r.Any("/api/v1/serve", ginserve.OffServe)
	port := os.Getenv("PORT")
	addr := fmt.Sprintf("0.0.0.0:%s", port)
	err := r.Run(addr)
	panic(err)
}
