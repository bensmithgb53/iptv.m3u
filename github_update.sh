#!/bin/bash

# 1. Clone the stalker-to-m3u tool into the runner workspace
git clone https://github.com/JuanBindez/stalker-to-m3u.git
cd stalker-to-m3u

# 2. Install dependencies (npm install is necessary for the script to run)
npm install

# 3. Create the config.json file directly on the runner
echo '{
  "hostname": "mag.jee-ott.xyz",
  "port": 80,
  "contextPath": "c",
  "mac": "00:1A:79:09:CB:D7",
  "tvgIdPreFill": true,
  "computeUrlLink": true,
  "vodMaxPagePerGenre": 2,
  "maxNumberOfChannelsToTest": 0,
  "testM3uFile": false,
  "streamTester": "ffmpeg"
}' > config.json

# 4. Use piping (echo -e "2\n1") to automate the interactive selections
#    This is the key to running the script automatically!
./stalker-to-m3u categories # Optional, but good practice
echo -e "2\n1" | ./stalker-to-m3u m3u --mode iptv

# 5. Move the generated file back to the main repository folder
mv iptv-mag.jee-ott.xyz.m3u ../iptv.m3u
cd ..

# 6. Commit and Push the updated file to GitHub
#    The git config lines set the commit author for the bot
git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"
git add iptv.m3u
git commit -m "Automated playlist refresh $(date +%F)" || echo "No playlist changes to commit."
git push

