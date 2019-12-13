#!/bin/zsh
e=$(networksetup -getsocksfirewallproxy Ethernet | grep "No")
if [ -n "$e" ]; then
  echo "Turning on sock_proxy"
  networksetup -setsocksfirewallproxystate Ethernet on
  echo 'display notification "ON" with title "proxy.sh"'  | osascript
else
  echo "Turning off sock_proxy"
  networksetup -setsocksfirewallproxystate Ethernet off
  echo 'display notification "OFF" with title "proxy.sh"' | osascript
fi
