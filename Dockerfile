FROM golang:alpine as base
ENV APP_BUILD_NAME="golang-test" \ 
    APP_PATH="/app" \ 
    APP_PORT="8000" \ 
    GO111MODULE=on
ADD ./ ${APP_PATH}
WORKDIR ${APP_PATH}
RUN apk update --no-cache && \ 
    apk add git
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags='-extldflags "-static"' -o ${APP_BUILD_NAME} . && \ 
    chmod +x ${APP_BUILD_NAME}
EXPOSE ${APP_PORT}
ENTRYPOINT ["/app/golang-test"]

FROM scratch as dev
ENV APP_BUILD_PATH="/app" \
    APP_BUILD_NAME="golang-test"
COPY --from=base ${APP_BUILD_PATH}/${APP_BUILD_NAME} /${APP_BUILD_PATH}/
WORKDIR ${APP_BUILD_PATH}
CMD ["./golang-test"]