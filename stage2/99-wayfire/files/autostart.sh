#!/bin/bash

until curl --output /dev/null --silent --head --fail http://localhost:3000/; do
  echo "Waiting for server..."
  sleep 1
done

chromium-browser --kiosk --ozone-platform=wayland --autoplay-policy=no-user-gesture-required http://localhost:3000/display/