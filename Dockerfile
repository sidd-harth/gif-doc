FROM alpine:3.10

# Install necessary packages
RUN apk update && \
    apk add --no-cache curl jq

# Copy your entrypoint script to the container
COPY entrypoint.sh /entrypoint.sh

# Make the script executable
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
