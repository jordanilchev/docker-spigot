# Version 1.0.1
#
# This version builds a spigot server
# using the recommended build strategy for spigot
# and use the output for run image creation
#
# This is advantageous in that it's better for plugin development
# and fits well with the Docker approach
#
# (Based on IBM article by Kyle Brown: https://developer.ibm.com/tutorials/minecraft-and-ibm-cloud-part-1/#about-the-spigot-dockerfile )
#

####
#
# Image:build
#
FROM openjdk:8-jdk-alpine as build

ARG VERSION=1.12.2

# Update git & wget
RUN apk add --update --no-cache git wget 

# Set global git config to fix CRLF
RUN git config --global core.autocrlf input

# Create build tool folder
RUN mkdir minecraft
# Download Spigot BuildTools to /minecraft folder
RUN wget "https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar" -O "minecraft/BuildTools.jar"
# Start the BuildTools with desired version
RUN java -Xms512m -Xmx1024m -jar "minecraft/BuildTools.jar" -rev $VERSION

#Rename output
RUN mv spigot-*.jar spigot.jar

####
#
# RUN image
#
FROM openjdk:8-jdk-alpine
LABEL maintainer="spigot-docker.box@ilchev.com"

COPY --from=build /spigot.jar /

# Add user minecraft and give permisions
RUN mkdir -p /data \
    mkdir -p /plugins \
    && adduser -D minecraft -h /home/minecraft \
    && chown -R minecraft /data /plugins /home/minecraft \
    && chmod -R 777 /data /home/minecraft

VOLUME ["/data","/plugins"]
WORKDIR /data

# Set startup user
USER minecraft

# Start command
CMD ln -sf /plugins /data/ \
    && java -Xmx2G -Xms2G -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=100 -XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1MixedGCLiveThresholdPercent=50 -XX:+AggressiveOpts -XX:+AlwaysPreTouch -XX:+UseLargePagesInMetaspace -d64 -Dcom.mojang.eula.agree=true -Dfile.encoding=UTF-8 -jar /spigot.jar nogui

# Expose default port
EXPOSE 25565
