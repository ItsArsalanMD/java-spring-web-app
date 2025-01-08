# Use an official Maven image to build the app
FROM maven:3.8.6-openjdk-17-slim AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml and dependencies to cache dependencies separately
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code
COPY src /app/src

# Build the application
RUN mvn clean install

# Use an official OpenJDK runtime as the base image
FROM openjdk:17-jre-slim

# Set the working directory
WORKDIR /app

# Copy the compiled jar file from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
