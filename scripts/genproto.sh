#!/bin/bash

source scripts/env

CUR_PATH=$(cd `dirname "$0"`;pwd)
ROOT_PATH=$CUR_PATH/..
# 生成*.pb.go文件
protoc -I. \
        -I/usr/local/include/ \
        -I${GOPATH}/src/ \
        -I${ROOT_PATH}/vendor/ \
        -I${ROOT_PATH}/proto/ \
        -I${ROOT_PATH}/vendor/github.com/grpc-ecosystem/grpc-gateway/ \
         -I${ROOT_PATH}/proto/github.com/googleapis/googleapis/ \
        --gogo_out=plugins=grpc,\
Mgoogle/protobuf/timestamp.proto=github.com/gogo/protobuf/types,\
Mgoogle/protobuf/duration.proto=github.com/gogo/protobuf/types,\
Mgoogle/protobuf/empty.proto=github.com/gogo/protobuf/types,\
Mgoogle/api/annotations.proto=github.com/gogo/googleapis/google/api,\
Mgoogle/protobuf/field_mask.proto=github.com/gogo/protobuf/types,\
Mgoogle/protobuf/struct.proto=github.com/gogo/protobuf/types:. \
        api/francisar/chatgpt/${API_VERSION}/*.proto

# 生成*.pb.gw.go与swagger接口文档
protoc -I. \
        -I/usr/local/include/ \
        -I${GOPATH}/src/ \
        -I${ROOT_PATH}/vendor/ \
        -I${ROOT_PATH}/proto/ \
        -I${ROOT_PATH}/vendor/github.com/grpc-ecosystem/grpc-gateway/ \
          -I${ROOT_PATH}/proto/github.com/googleapis/googleapis/ \
        --grpc-gateway_out=allow_patch_feature=false,allow_repeated_fields_in_body=true,\
Mgoogle/protobuf/timestamp.proto=github.com/gogo/protobuf/types,\
Mgoogle/protobuf/duration.proto=github.com/gogo/protobuf/types,\
Mgoogle/protobuf/empty.proto=github.com/gogo/protobuf/types,\
Mgoogle/api/annotations.proto=github.com/gogo/googleapis/google/api,\
Mgoogle/protobuf/field_mask.proto=github.com/gogo/protobuf/types,\
Mgoogle/protobuf/struct.proto=github.com/gogo/protobuf/types:. \
        --swagger_out=logtostderr=true,allow_repeated_fields_in_body=true:./public/doc/openapi-spec/ \
        api/francisar/chatgpt/${API_VERSION}/microservice.proto
