FROM golang:alpine as baseimage
ENV APP_BUILD_NAME="golang-test" \ 
    APP_PATH="/app" \ 
    APP_PORT="8000" \ 
    GO111MODULE=on
ADD ./ ${APP_PATH}
WORKDIR ${APP_PATH}
RUN apk update --no-cache && \ 
    apk add git
RUN go build -o ${APP_BUILD_NAME} main.go && \ 
    chmod +x ${APP_BUILD_NAME}
EXPOSE ${APP_PORT}
ENTRYPOINT ["/app/golang-test"]

FROM baseimage as build
RUN (([ ! -d "${APP_PATH}/vendor" ] && go mod download && go mod vendor) || true)
RUN go build -ldflags="-s -w" -mod vendor -o ${APP_BUILD_NAME} main.go
RUN chmod +x ${APP_BUILD_NAME}

FROM scratch as prod
ENV APP_BUILD_PATH="/app" \
    APP_BUILD_NAME="golang-test"
WORKDIR ${APP_BUILD_PATH}
COPY --from=build ${APP_BUILD_PATH}/${APP_BUILD_NAME} ${APP_BUILD_PATH}/
EXPOSE ${APP_PORT}
ENTRYPOINT ["/app/golang-test"]
CMD ""