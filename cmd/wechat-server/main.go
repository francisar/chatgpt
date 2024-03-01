package main

import (
	"fmt"
	"github.com/francisar/chatgpt/ginserve"
	"github.com/gin-gonic/gin"
	"github.com/spf13/viper"
	"os"
)

func main()  {
	viper.SetConfigType("env")
	r := gin.Default()
	// 传入request和responseWriter
	r.Any("/", ginserve.OffServe)
	r.Any("/health", ginserve.HealthServe)
	port := os.Getenv("PORT")
	ip := os.Getenv("IP_ADDR")
	addr := fmt.Sprintf("%s:%s", ip, port)
	err := r.Run(addr)
	panic(err)
}
