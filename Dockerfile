# Verwende das offizielle Gradle-Image, um den Build durchzuführen
FROM gradle:8.4.0-jdk17 AS build

# Kopiere den Quellcode in das Container-Dateisystem
COPY --chown=gradle:gradle . /home/gradle/src

# Wechsle das Arbeitsverzeichnis
WORKDIR /home/gradle/src

# Führe den Gradle-Shadow-Build aus, um ein ausführbares JAR zu erstellen
RUN gradle shadowJar --no-daemon

# Verwende das offizielle OpenJDK-Image für die Laufzeitumgebung
FROM openjdk:17-slim

# Kopiere das gebaute ausführbare JAR aus dem Build-Container
COPY --from=build /home/gradle/src/build/libs/*.jar /app/TwitchTube.jar

# Setze das Arbeitsverzeichnis für den Container
WORKDIR /app

# Definiere einen Eintrittspunkt, der den Discord-Token als Argument akzeptiert
ENTRYPOINT ["java", "-jar", "TwitchTube.jar"]
CMD ["--help"]
# Standardargument, falls kein Token übergeben wird
