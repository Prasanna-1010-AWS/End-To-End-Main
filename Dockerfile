# -------------------------------
# Stage 1: Build the Go application
# -------------------------------
FROM golang:1.23 AS builder

# Set working directory inside container
WORKDIR /app

# Copy go.mod and go.sum if exists
COPY go.mod go.sum ./

# Download dependencies (silent, safe even if go.sum missing)
RUN go mod tidy

# Copy the rest of the source code
COPY . .

# Build the Go binary
RUN go build -o main .

# -------------------------------
# Stage 2: Minimal runtime image
# -------------------------------
FROM gcr.io/distroless/base

# Copy the compiled binary
COPY --from=builder /app/main .

# Copy static files if you have any
COPY --from=builder /app/static ./static

# Expose the application port
EXPOSE 8080

# Command to run the application
CMD ["./main"]
