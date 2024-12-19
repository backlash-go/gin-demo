package main

import "github.com/gin-gonic/gin"

func main() {
	r := gin.Default()
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})
	// 启动 HTTP 服务，监听 13131 端口
	if err := r.Run(":13131"); err != nil {
		panic(err)
	}
}
