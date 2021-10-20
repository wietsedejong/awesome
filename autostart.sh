#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}
#run "xrandr --output VGA-1 --primary --mode 1360x768 --pos 0x0 --rotate normal"
#run "xrandr --output HDMI2 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off"
run "nm-applet"
run "usr/bin/octopi-notifier"
#run "pamac-tray"
run "xfce4-power-manager"
#run "blueberry-tray"
run "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
run "numlockx on"
#run "volumeicon"
run "nitrogen --restore"
run "syncthing-gtk -m"
#run "nextcloud"
#run "conky -c $HOME/.config/awesome/system-overview"
#run "insync start"
#run "spotify"
