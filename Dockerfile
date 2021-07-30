# build stage
FROM --platform=$BUILDPLATFORM golang as builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM

ENV GO111MODULE=on

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETPLATFORM go build

# final stage
FROM scratch
COPY --from=builder /app/httpserver /app/
EXPOSE 8080
ENTRYPOINT ["/app/httpserver"]
