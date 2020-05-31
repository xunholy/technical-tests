## Stage 1
FROM golang:alpine AS build

ENV GO111MODULE=on

WORKDIR /app

RUN apk update && apk add --no-cache git

COPY . .

RUN go get -d -v && go mod verify

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o golang-test .

## Stage 2
FROM scratch

WORKDIR /app

COPY --from=build /app/golang-test .

ENTRYPOINT ["/app/golang-test"]

EXPOSE 8000
