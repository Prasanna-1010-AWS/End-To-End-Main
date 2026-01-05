FROM golang:1.22 AS builder

WORKDIR /app

# Copy only go.mod
COPY go.mod ./

# Download deps safely (works even without go.sum)
RUN go mod tidy

# Copy source
COPY . .

# Build binary
RUN go build -o main .

# ---- runtime image ----
FROM gcr.io/distroless/base

COPY --from=builder /app/main /main

EXPOSE 8080

CMD ["/main"]
