#build stage
FROM golang:alpine AS builder
RUN apk add --no-cache git
WORKDIR /go/src/app
ENV PATH="/go/bin:${PATH}"
COPY . .
RUN go get -d -v ./...
RUN go build -o /go/bin/app -v ./...
CMD ["tail", "-f", "/dev/null"]

#final stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder /go/bin/app /app
ENTRYPOINT /app
LABEL Name=webservicegin Version=0.0.1
EXPOSE 8080
CMD ["tail", "-f", "/dev/null"]
