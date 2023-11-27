# Build stage
FROM golang:1.21-alpine3.18 AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go
# RUN wget -O /usr/local/bin/migrate https://github.com/golang-migrate/migrate/releases/download/v4.16.2/migrate.linux-386.tar.gz && \
#     chmod +x /usr/local/bin/migrate
RUN apk add curl
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.16.2/migrate.linux-amd64.tar.gz | tar xvz
          
# Run stage
FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/migrate /app/migrate
COPY --from=builder /app/db/migration /app/db/migration
COPY app.env .
# COPY db/migration /app/migration
COPY start.sh .
COPY wait-for.sh .
# COPY wait-for-it.sh /app/wait-for-it.sh

RUN chmod +x /app/wait-for.sh

# ENV POSTGRES_USER=root \
#     POSTGRES_DB=simple_bank \
#     POSTGRES_HOST=postgres \
#     POSTGRES_PORT=5432
    # POSTGRES_PASSWORD=secret \
    # DB_SOURCE=postgresql://root:secret@postgres:5432/simple_bank?sslmode=disable

# Add the ENV instruction here to set the GOMAXPROCS environment variable
# ENV GOMAXPROCS=1

# Copy the entrypoint script
# COPY entrypoint.sh /app/entrypoint.sh

# Set execute permissions for the entrypoint script
RUN chmod +x /app/start.sh
RUN chmod +x /app/migrate


EXPOSE 8081
CMD [ "/app/main" ]
ENTRYPOINT [ "/app/start.sh" ]
# CMD ["./wait-for-it.sh", "postgres:5432", "--", "./main", "migrate"]
# Command to run the entrypoint script
# CMD ["./start.sh"]
