FROM golang:1.22-alpine AS builder
RUN apk add --no-cache gcc musl-dev
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
RUN CGO_ENABLED=1 GOOS=linux go build -o /tracker

FROM alpine:latest
RUN apk add --no-cache libc6-compat
COPY --from=builder /tracker /tracker
COPY tracker.db /tracker.db
ENTRYPOINT ["/tracker"]
