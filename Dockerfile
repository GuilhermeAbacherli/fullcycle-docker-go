# syntax=docker/dockerfile:1

###################################
# STEP 1 build executable binary
###################################
FROM golang:alpine AS builder

# Set destination for COPY
WORKDIR /app

# Download Go modules
# COPY go.mod go.sum ./
COPY go.mod ./
RUN go mod download

# Copy the source code. Note the slash at the end, as explained in
# https://docs.docker.com/engine/reference/builder/#copy
COPY *.go ./

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /app/fullcycle

###################################
# STEP 2 build a small image
###################################
FROM scratch

# Copy our static executable
COPY --from=builder /app/fullcycle /app/fullcycle

# Run the binary
ENTRYPOINT ["/app/fullcycle"]
