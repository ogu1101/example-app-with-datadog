# Example App with Datadog

## Overview

This repository contains a Java-based application built on the Spring Boot framework, serving as a verification environment for Datadog support operations. The application exposes a REST API and registers data into a PostgreSQL container.

## Prerequisites

Before running the Datadog Agent and the application, ensure the following configurations:

1. Set Datadog API Key in the `.env` file:
   - Update the `DD_API_KEY` in the `.env` file with your Datadog API Key.

2. Configure Datadog API Key in `application.properties`:
   - Update the `management.datadog.metrics.export.apiKey` in the `application.properties` file with your Datadog API Key.

## Features Enabled

### Datadog Observability

| Feature                              | Description                                             |
| ------------------------------------ | ------------------------------------------------------- |
| **Log Management**                   | JSON-formatted logs for enhanced readability.           |
| **APM (Application Performance Monitoring)** | Comprehensive monitoring of application performance. |
| **Continuous Profiler**              | Utilizes the Continuous Profiler feature, including ASM (Assembly) support. |
| **DBM (Database Monitoring)**        | APM and Database Monitoring are correlated for holistic insights. |
| **CI Visibility**                    | Integration with CI (Continuous Integration) for visibility into the build process. |
| **Link Source Code**                 | Seamless debugging experience with source code linkage. |
| **Process Monitoring**               | Datadog's process monitoring functionality is also enabled. |

## Containerized Services

The entire environment is containerized using Docker for easy deployment and management:

- **Services:**
  - Application
  - PostgreSQL
  - Datadog Agent
  - Jenkins

- **Configuration:**
  - Managed through `docker-compose.yaml`.

## Build and Execution

### Building the Application

Use the following command to build the application:

```bash
docker build . \
    -t example-app-with-datadog-app \
    --build-arg DD_GIT_REPOSITORY_URL=github.com/ogu1101/example-app-with-datadog \
    --build-arg DD_GIT_COMMIT_SHA=$(git rev-parse HEAD)
```

### Running the Containers

Execute the following command to run the containers:

```bash
docker-compose up -d
```

### Sending an HTTP Request

To send an HTTP request to the application, use the following command:

```bash
curl -v -X POST -H 'Content-Type:application/json' -d '{"message":"Hello", "target":"Kagetaka"}' 127.0.0.1:8080/greeting
```

## Jenkins Integration

**Note:**

- Jenkins integration requires manual installation of the Datadog plugin and configuration of CI jobs.

Jenkins is seamlessly integrated into the environment. Access Jenkins using the following URL:

http://localhost:8888

***

Feel free to explore, test, and contribute to this repository for Datadog support validation purposes.

README created by ChatGPT.