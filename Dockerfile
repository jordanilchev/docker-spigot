# Version 1.0.0
# This version builds a spigot server
# using the recommended build strategy for spigot
# This is advantageous in that it's better for plugin development
# and fits well with the Docker approach
# based on IBM article by Kyle Brown: https://developer.ibm.com/tutorials/minecraft-and-ibm-cloud-part-1/#about-the-spigot-dockerfile
#

FROM java:8
LABEL maintainer="spigot-docker.box@ilchev.com"

RUN mkdir minecraft

# Download Spigot BuildTools to /minecraft folder
RUN wget "https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar" -O "minecraft/BuildTools.jar"

# Set global git config to fix CRLF
RUN git config --global core.autocrlf input

# Start the BuildTools with desired version
RUN java -Xms512m -Xmx1024m -jar "minecraft/BuildTools.jar" -rev 1.12.2

# Accept the EULA for the server
RUN echo "eula=true" > eula.txt

# Start the server command
CMD java -Xms512m -Xmx1024m -jar spigot-1.12.2.jar nogui

# Expose default port
EXPOSE 25565
