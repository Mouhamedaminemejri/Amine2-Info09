FROM maven:3.8.4-openjdk-17-slim AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml file to the container
COPY pom.xml .

# Copy the rest of the application code
COPY src ./src

# Build the application with Maven
RUN mvn clean package -DskipTests

# Use a smaller base image for the runtime environment
FROM library/maven:3.8.4-openjdk-17-slim AS runtime
# Set the working directory in the container
WORKDIR /app

# Copy the compiled application JAR file from the build stage to the runtime image
COPY --from=build /app/target/*.jar ./app.jar

# Expose the port that the application listens on
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.jar"]