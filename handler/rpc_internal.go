// Code generated by "grpc-kit-cli/0.2.3". DO NOT EDIT.

package handler

import (
    "context"

    "github.com/grpc-kit/pkg/errors"
    hz "google.golang.org/grpc/health/grpc_health_v1"
)

// HealthCheck 用于健康检测
func (m Microservice) HealthCheck(ctx context.Context, req *hz.HealthCheckRequest) (*hz.HealthCheckResponse, error) {
    if req.Service == m.code {
        return &hz.HealthCheckResponse{
            Status: hz.HealthCheckResponse_SERVING,
        }, nil
    }

    return nil, errors.NotFound(ctx).WithMessage("unknown service").Err()
}