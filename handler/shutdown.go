// Code generated by "grpc-kit-cli/0.2.3". DO NOT EDIT.

package handler

import (
	"context"
	"time"
)

// Shutdown 优雅关闭gRPC与HTTP服务
func (m *Microservice) Shutdown(ctx context.Context) error {
	m.logger.Warnf("Shutdown server begin")

	if err := m.baseCfg.Deregister(); err != nil {
		return err
	}

	// 最长等待关闭的时间，例如超过30秒则强制关闭gateway
	ctx, cancel := context.WithTimeout(ctx, time.Second*30)
	defer cancel()

	// 阻塞等待，直到所有连接正常或超时退出
	if err := m.server.Shutdown(ctx); err != nil {
		return err
	}

	m.logger.Warnf("Shutdown server end")
	return nil
}
