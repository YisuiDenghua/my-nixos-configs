''
  @import "/etc/nixos/home/yisui/waybar/macchiato.css";
  * {
    /* `otf-font-awesome` is required to be installed for icons */
    font-family: Material Design Icons, Iosevka Nerd Font;
  }
  window#waybar {
    background-color: @base;
    border-radius: 0px;
    color: @mantle;
    font-size: 20px;
    /* transition-property: background-color; */
    transition-duration: 0.5s;
  }
  window#waybar.hidden {
    opacity: 0.2;
  }
  #workspaces {
    font-size: 15px;
    background-color: #414559;
  }
  #pulseaudio {
    color: #a6d189;
  }
  #network {
    color: #8caaee;
  }
  #custom-search,
  #custom-weather,
  #clock {
    color: #c6d0f5;
    background-color: #414559;
  }
  #workspaces button {
    background-color: transparent;
    /* Use box-shadow instead of border so the text isn't offset */
    color: @mantle;
    font-size: 21px;
    padding-left: 6px;
    box-shadow: inset 0 -3px transparent;
    transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.68);
  }
  #workspaces button:hover {
    color: #85c1dc;
    box-shadow: inherit;
    text-shadow: inherit;
  }
  #custom-power {
      color: #e78284;
  }
  #workspaces button.active {
    color: #e5c890;
    transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
  }
  #workspaces button.urgent {
    background-color: #e78284;
  }
  #custom-weather,
  #clock,
  #network,
  #custom-swallow,
  #cpu,
  #battery,
  #backlight,
  #memory,
  #workspaces,
  #custom-search,
  #custom-power,
  #custom-todo,
  #custom-lock,
  #custom-weather,
  #custom-btc,
  #custom-eth,
  #volume,
  #pulseaudio {
    border-radius: 15px;
    margin: 0px 7px 0px 7px;
    background-color: #414559;
    padding: 10px 0px 10px 0px;
  }
  #custom-swallow {
    color: #ca9ee6;
    padding-right: 3px;
  }
  #custom-lock {
      color: #8caaee;
      padding-right: 1px;
  }
  #custom-todo {
    color: #c6d0f5;
    padding-left: 2px;
  }
  #custom-power {
    margin-bottom: 7px;
  }
  #custom-search {
    background-image: url("${./sakura.png}");
    background-size: 60%;
    background-position: center;
    background-repeat: no-repeat;
    margin-top: 7px;
  }
  #clock {
    font-weight: 700;
    font-size: 20px;
    padding: 5px 0px 5px 0px;
    font-family: "Iosevka Term";
  }
  #backlight {
    color: #e5c890;
  }
  #battery {
    color: #a6d189;
  }
  #battery.warning {
    color: #ef9f76;
  }
  #battery.critical:not(.charging) {
    color: #e78284;
  }
  tooltip {
    font-family: 'Lato', sans-serif;
    border-radius: 15px;
    padding: 20px;
    margin: 30px;
  }
  tooltip label {
    font-family: 'Lato', sans-serif;
    padding: 20px;
  }
''
