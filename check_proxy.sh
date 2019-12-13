#!/bin/zsh
e=$(networksetup -getsocksfirewallproxy Ethernet | grep "No")
if [ -n "$e" ]; then
  echo 'display notification "OFF" with title "sock_proxy"'  | osascript
else
  echo 'display notification "ON" with title "sock_proxy"' | osascript
fi
