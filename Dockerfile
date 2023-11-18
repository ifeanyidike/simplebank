# Build stage
FROM golang:1.21-alpine3.18 AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go
RUN apk add curl
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.16.2/migrate.linux-386.tar.gz | tar xvz
          
# Run stage
FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/migrate ./migrate
COPY app.env .
COPY db/migration /app/migration
COPY start.sh .
COPY wait-for.sh .

# Add the ENV instruction here to set the GOMAXPROCS environment variable
ENV GOMAXPROCS=1

# RUN chmod +x /app/migrate
# RUN chmod +x /app/start.sh
# RUN chmod +x /app/wait-for.sh

EXPOSE 8081
CMD [ "/app/main" ]
ENTRYPOINT [ "/app/start.sh" ]
