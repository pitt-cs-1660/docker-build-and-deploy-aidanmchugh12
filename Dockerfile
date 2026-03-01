# Build stage
FROM golang:1.23 AS buildstage

WORKDIR /app

COPY go.mod .
COPY main.go . 
COPY templates/ templates/

RUN go mod download
RUN CGO_ENABLED=0 go build -o app .


# Final stage
FROM scratch

WORKDIR /app

COPY --from=buildstage /app/app .
COPY --from=buildstage /app/templates/ templates/

ENTRYPOINT ["/app/app"]