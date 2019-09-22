# Minecraft Spigot server built fresh from source for specific version

## Quick run
```bash
docker run -i -t -p 25565:25565 jordanilchev/spigot:1.12.2
```

## Run with custom /data and /plugins folders
```bash
docker run -i -t -p 25565:25565 -v "$(pwd)"/data:/data -v "$(pwd)"/plugins:/plugins jordanilchev/spigot:1.12.2
```
