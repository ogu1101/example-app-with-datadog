# Stage 1: Build Stage
FROM maven:3-amazoncorretto-17 AS build

# Set working directory
WORKDIR /app

# Copy source code and POM file
COPY src /app/src
COPY pom.xml /app/pom.xml

# Build the application
RUN mvn clean package -Dmaven.test.skip=true \
    && yum install -y wget \
    && wget -O dd-java-agent.jar 'https://dtdg.co/latest-java-tracer'

# Stage 2: Production Stage
FROM amazoncorretto:17

# Set build arguments and environment variables
ARG DD_GIT_REPOSITORY_URL
ARG DD_GIT_COMMIT_SHA
ENV DD_AGENT_HOST="datadog-agent" \
    DD_APPSEC_ENABLED=true \
    DD_DBM_PROPAGATION_MODE=service \
    DD_GIT_REPOSITORY_URL=${DD_GIT_REPOSITORY_URL} \
    DD_GIT_COMMIT_SHA=${DD_GIT_COMMIT_SHA} \
    DD_IAST_ENABLED=true \
    DD_LOGS_INJECTION=true \
    DD_PROFILING_ENABLED=true \
    DD_TRACE_AGENT_PORT="8126"

# Copy JAR file and Datadog Java Agent from the build stage
COPY --from=build /app/target/example-app-with-datadog-0.0.1-SNAPSHOT.jar /app.jar
COPY --from=build /app/dd-java-agent.jar /dd-java-agent.jar

# Set the command to run the application
CMD ["java", "-javaagent:/dd-java-agent.jar", "-Ddd.integration.jdbc-datasource.enabled=true", "-XX:FlightRecorderOptions=stackdepth=256", "-jar", "/app.jar"]
