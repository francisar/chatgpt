package handler

import (
	"context"
	pb "github.com/francisar/chatgpt/api/francisar/chatgpt/v1"

	"github.com/gogo/protobuf/types"
    "github.com/grpc-kit/pkg/api"

	// pb "github.com/francisar/chatgpt/api/francisar/chatgpt/v1"
)

// Demo test
func (m Microservice) Demo(ctx context.Context, req *pb.DemoRequest) (*pb.DemoResponse, error) {
	m.logger.Warnf("test demo warn: %v", "func Demo")

	result := &pb.DemoResponse{
	    // GET /api/demo
	    Content:  []*api.ExampleResponse{
	        {Name: "grpc-kit-cli"},
            {Name: "grpc-kit-cfg"},
            {Name: "grpc-kit-pkg"},
            {Name: "grpc-kit-api"},
            {Name: "grpc-kit-web"},
            {Name: "grpc-kit-doc"},
        },
        Ping:  &api.ExampleResponse{},
        // POST /api/demo
        // GET /api/demo/{uuid}
        Pong: &pb.DemoResponse_Pong{
	        Uuid: "99feafb5-bed6-4daf-927a-69a2ab80c485",
	        Pong: &api.ExampleResponse{},
        },
        // DELETE /api/demo/{uuid}
        Empty: &types.Empty{},
    }

    if req.Ping != nil {
        result.Ping.Name = req.Ping.Name
        result.Pong.Pong.Name = req.Ping.Name
    }

    if req.Uuid == "99feafb5-bed6-4daf-927a-69a2ab80c485" {
        result.Pong.Pong.Name = "grpc-kit"
    }

    return result, nil
}
