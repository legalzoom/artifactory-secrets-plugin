FROM --platform=$BUILDPLATFORM golang:1.14 as builder
ARG TARGETPLATFORM

WORKDIR /workspace

COPY go.mod go.mod
COPY go.sum go.sum

RUN go mod download
COPY cmd/ cmd/
COPY *.go .

RUN CGO_ENABLED=0 GOARCH=arm64 go build -o vault/plugins/artifactory cmd/artifactory/main.go

FROM alpine
COPY --from=builder /workspace/vault/plugins/artifactory /vault-plugin 

