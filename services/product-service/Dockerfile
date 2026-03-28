# Placeholder Dockerfile for Product Service
# Replace this file with your actual application Dockerfile
FROM eclipse-temurin:17-jdk-jammy as build
WORKDIR /app
COPY . .
RUN ./mvnw clean install
COPY pom.xml.
RUN ./mvnw package -DskipTests
RUN java -Djar target=app.jar -DskipTests
COPY target/*.jar app.jar
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /app/app.jar app.jar
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=5 curl -f http://localhost:8080/actuator/health || exit 1
cmd ["java", "-jar", "app.jar"]
