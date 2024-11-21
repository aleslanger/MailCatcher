# MailCatcher Docker Image

## Description
This Docker image provides a simple and efficient way to run MailCatcher—a tool for capturing emails during application development. The image is based on Ruby 2.7 and Alpine Linux 3.18, ensuring compatibility, low size, and high performance.

## What is MailCatcher?
MailCatcher is a lightweight SMTP server and web interface that allows developers to capture and view sent emails without the need for a real email server. It is ideal for testing email functionalities in your applications.

## Features
Lightweight and Fast: Built on Alpine Linux to minimize image size.
Security: Runs under a non-privileged user.
HEALTHCHECK: Monitors the status of MailCatcher and ensures its availability.
Metadata: Includes essential metadata for easy management and identification of the image.
## How to Use

### Pull the Image
First, pull the image from Docker Hub:
```sh
docker pull aleslanger/mailcatcher:last
```
### Run the Container
Start the MailCatcher container using the following command:

```sh
docker run -d \
  --name mailcatcher \
  -p 1025:1025 \
  -p 1080:1080 \
  aleslanger/mailcatcher:last
```
This command maps port 1025 (SMTP) and port 1080 (web interface) on your host to the container.

### Verify the Container is Running
Check the logs to ensure MailCatcher starts correctly:

```sh
docker logs -f mailcatcher
```
## Configuration
### Environment Variables
This image does not require any additional environment variables by default. However, you can modify the Dockerfile if you need to customize configurations further.

### Exposed Ports
1025: SMTP server for sending emails.
1080: Web interface for viewing captured emails.
### Examples
Running with Data Persistence
To retain captured emails between container restarts, you can mount a volume:

```sh
docker run -d \
  --name mailcatcher \
  -p 1025:1025 \
  -p 1080:1080 \
  -v mailcatcher_data:/home/mailcatcher \
  yourusername/mailcatcher:last
```
### Using Docker Compose
#### create a docker-compose.yml file:

```yaml
version: '3.8'

services:
  mailcatcher:
    image: aleslanger/mailcatcher:last
    container_name: mailcatcher
    ports:
      - "1025:1025"
      - "1080:1080"
    volumes:
      - mailcatcher_data:/home/mailcatcher
    restart: unless-stopped

volumes:
  mailcatcher_data:
```


#### Start the service with:


```sh
docker-compose up -d
```

### HEALTHCHECK
This image includes a HEALTHCHECK that regularly checks the availability of MailCatcher on port 1080. If the check fails, Docker will automatically restart the container.

## License
This project is licensed under the MIT License.

## Author
Created by Aleš Langer
