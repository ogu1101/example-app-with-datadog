# Use the latest Jenkins image with JDK 17 as the base image
FROM jenkins/jenkins:latest-jdk17

# Environment variables for Datadog Jenkins plugin configuration
ENV DATADOG_JENKINS_PLUGIN_REPORT_WITH=DSD \
    DATADOG_JENKINS_PLUGIN_TARGET_HOST=datadog-agent \
    DATADOG_JENKINS_PLUGIN_TARGET_TRACE_COLLECTION_PORT=8126 \
    DATADOG_JENKINS_PLUGIN_ENABLE_CI_VISIBILITY=true \
    DATADOG_JENKINS_PLUGIN_CI_VISIBILITY_CI_INSTANCE_NAME=jenkins \
    DD_CI_HOSTNAME=jenkins \
    DD_CIVISIBILITY_ENABLED=true \
    DD_TRACER_FOLDER=/ \
    DD_TRACE_AGENT_URL=http://datadog-agent:8126 \
    MAVEN_OPTS=-javaagent:/dd-java-agent.jar

# Set a label for Datadog log integration
LABEL com.datadoghq.ad.logs='[{"source":"jenkins", "service":"jenkins"}]'

# Switch to the root user to update packages and install wget and Maven
USER root

# Install required packages
RUN apt-get update \
    && apt-get install -y wget maven

# Download Datadog Java Tracer
RUN wget -P / -O dd-java-agent.jar 'https://dtdg.co/latest-java-tracer' \
    && chown jenkins /dd-java-agent.jar

# Switch back to the Jenkins user for subsequent operations
USER jenkins
