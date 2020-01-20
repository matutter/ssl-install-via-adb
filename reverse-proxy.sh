adb reverse --remove-all

adb shell cat /etc/hosts && \
  adb reverse tcp:8080 tcp:8080 && \
  adb reverse tcp:8443 tcp:8443 && \
  adb reverse --list
