FROM golang:alpine

ENV GO111MODULE=on

WORKDIR /app

ADD ./ /app

RUN apk update --no-cache

RUN apk add git

RUN go build -o golang-test  .

ENTRYPOINT ["/app/golang-test"]

EXPOSE 8000
