##
## Build
##
FROM golang:1.18-alpine AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
COPY src/helper/yaml.go /usr/local/go/src/helper/yaml.go
RUN go mod download

COPY *.go ./

RUN go build -o /idp
RUN apk update && apk add curl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

##
## Deploy
##
FROM alpine:latest

WORKDIR /root/

COPY --from=build /idp .
COPY --from=build /app/kubectl /usr/local/bin/kubectl
RUN chmod u+x /usr/local/bin/kubectl
COPY src/html/ src/html/
EXPOSE 8080

# USER nonroot:nonroot

ENTRYPOINT ["/root/idp"]