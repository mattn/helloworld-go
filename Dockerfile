# syntax=docker/dockerfile:1.4

FROM golang:1.23-alpine AS build-dev
WORKDIR /go/src/app
COPY --link go.mod go.sum ./
RUN apk add --no-cache upx || \
    go version && \
    go mod download
COPY --link . .
RUN CGO_ENABLED=0 go install -buildvcs=false -trimpath -ldflags '-w -s'
RUN [ -e /usr/bin/upx ] && upx /go/bin/helloworld-go || echo
FROM scratch
COPY --link --from=build-dev /go/bin/helloworld-go /go/bin/helloworld-go
COPY --from=build-dev /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["/go/bin/helloworld-go"]
