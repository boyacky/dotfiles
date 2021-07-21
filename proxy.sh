#!/bin/zsh
#e=$(networksetup -getsocksfirewallproxy "Belkin USB-C LAN" | grep "No")
#if [ -n "$e" ]; then
#  echo "Turning on sock_proxy"
#  networksetup -setsocksfirewallproxystate "Belkin USB-C LAN" on
#  echo 'display notification "ON" with title "proxy.sh"'  | osascript
#else
#  echo "Turning off sock_proxy"
#  networksetup -setsocksfirewallproxystate "Belkin USB-C LAN" off
#  echo 'display notification "OFF" with title "proxy.sh"' | osascript
#fi

e=$(networksetup -getsocksfirewallproxy "Wi-Fi" | grep "No")
if [ -n "$e" ]; then
  echo "Turning on sock_proxy"
  networksetup -setsocksfirewallproxystate "Wi-Fi" on
  echo 'display notification "ON" with title "proxy.sh"'  | osascript
else
  echo "Turning off sock_proxy"
  networksetup -setsocksfirewallproxystate "Wi-Fi" off
  echo 'display notification "OFF" with title "proxy.sh"' | osascript
fi
