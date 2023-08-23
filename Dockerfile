FROM maven:3.9.3-amazoncorretto-17 AS build

COPY src /app/src
COPY pom.xml /app/pom.xml

WORKDIR /app
RUN mvn clean package

FROM amazoncorretto:17
COPY --from=build /app/target/jersey-demo-0.0.1-SNAPSHOT.jar /app.jar

COPY dd-java-agent.jar /dd-java-agent.jar

ENV DD_AGENT_HOST="datadog-agent"
ENV DD_TRACE_AGENT_PORT="8126"

ENV DD_PROFILING_ENABLED=true
ENV DD_LOGS_INJECTION=true
ENV DD_APPSEC_ENABLED=true

CMD ["java", "-javaagent:/dd-java-agent.jar", "-jar", "/app.jar"]