FROM maven:3.9.3-amazoncorretto-17 AS build

COPY src /app/src
COPY pom.xml /app/pom.xml

WORKDIR /app
RUN mvn clean package -Dmaven.test.skip=true

FROM amazoncorretto:17
COPY --from=build /app/target/example-app-with-datadog-0.0.1-SNAPSHOT.jar /app.jar
COPY dd-java-agent.jar /dd-java-agent.jar

ARG DD_GIT_REPOSITORY_URL
ARG DD_GIT_COMMIT_SHA

ENV DD_AGENT_HOST="datadog-agent"
ENV DD_APPSEC_ENABLED=true
ENV DD_DBM_PROPAGATION_MODE=service
ENV DD_GIT_REPOSITORY_URL=${DD_GIT_REPOSITORY_URL}
ENV DD_GIT_COMMIT_SHA=${DD_GIT_COMMIT_SHA}
ENV DD_IAST_ENABLED=true
ENV DD_LOGS_INJECTION=true
ENV DD_PROFILING_ENABLED=true
ENV DD_TRACE_AGENT_PORT="8126"

CMD ["java", "-javaagent:/dd-java-agent.jar", "-Ddd.integration.jdbc-datasource.enabled=true", "-XX:FlightRecorderOptions=stackdepth=256", "-jar", "/app.jar"]
