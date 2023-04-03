{ config, pkgs, lib, options,  ... }:
{

  services.minecraft-server.package = pkgs.minecraft-server_1_18_2;
  services.minecraft-server.enable = true;
  services.minecraft-server.eula = true;
  services.minecraft-server.jvmOpts = "-Xms4092M -Xmx4092M -XX:+UseG1GC -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";
  services.minecraft-server.dataDir = "./data";
  services.minecraft-server.declarative = true;
  services.minecraft-server.serverProperties = {
    server-port = 25565;
    difficulty = 1;
    gamemode = "survival";
    # max-players = 5;
    motd = "NixOS Minecraft server!";
    # white-list = true;
    # enable-rcon = true;
    # "rcon.password" = "hunter2";
    online-mode = false;
  };

}
