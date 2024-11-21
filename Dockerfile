# Stage 1: Build
FROM ruby:3.3-alpine3.18 AS builder

# Define environment variables
ENV MAILCATCHER_VERSION=0.10.0 \
    BUILD_DEPS="build-base sqlite-dev"

# Install build dependencies, update RubyGems, install necessary gems, and clean up
RUN apk add --no-cache $BUILD_DEPS sqlite-libs curl \
    && gem update --system \
    && gem install sqlite3 -v '~>1.3' --platform=ruby --no-document \
    && gem install mailcatcher -v "${MAILCATCHER_VERSION}" --no-document \
    && apk del $BUILD_DEPS

# Stage 2: Final
FROM ruby:3.3-alpine3.18

LABEL maintainer="ales.langer@yahoo.com" \
      version="0.1" \
      description="MailCatcher Docker image based on Ruby 3.3 and Alpine 3.18"

# Install runtime dependencies and create a non-privileged user and group in one RUN command
RUN apk add --no-cache sqlite-libs curl \
    && addgroup -S mailcatcher \
    && adduser -S mailcatcher -G mailcatcher

# Copy installed gems from the builder stage
COPY --from=builder /usr/local/bundle /usr/local/bundle

# Set the working directory and change ownership
WORKDIR /home/mailcatcher
RUN mkdir -p /home/mailcatcher && chown mailcatcher:mailcatcher /home/mailcatcher

# Expose necessary ports
EXPOSE 1025 1080

# Define HEALTHCHECK to ensure the service is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:1080/ || exit 1

# Switch to the non-privileged user
USER mailcatcher

# Command to start MailCatcher
CMD ["mailcatcher", "--foreground", "--ip=0.0.0.0"]
