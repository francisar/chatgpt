package handler

import (
	"fmt"
	"net/http"

	"google.golang.org/grpc"
)

func (m *Microservice) privateExtended() error {
	clientOpts := m.baseCfg.GetClientDialOption()
	clientUnaryHandlers := m.baseCfg.GetClientUnaryInterceptor()
	clientStreamHandlers := m.baseCfg.GetClientStreamInterceptor()

	m.client.UseDialOption(clientOpts...).
		UseUnaryInterceptor(clientUnaryHandlers...).
		UseStreamInterceptor(clientStreamHandlers...)

	m.server.UseServerOption(m.baseCfg.GetUnaryInterceptor(m.privateUnaryServerInterceptor()...),
		m.baseCfg.GetStreamInterceptor(m.privateStreamServerInterceptor()...))

	return nil
}

func (m *Microservice) privateUnaryServerInterceptor() []grpc.UnaryServerInterceptor {
	return nil
}

func (m *Microservice) privateStreamServerInterceptor() []grpc.StreamServerInterceptor {
	return nil
}

func (m *Microservice) privateHTTPHandle(mux *http.ServeMux) {
	mux.HandleFunc("/favicon.ico", func(w http.ResponseWriter, r *http.Request) {
		_, _ = fmt.Fprintf(w, "")
	})
}
