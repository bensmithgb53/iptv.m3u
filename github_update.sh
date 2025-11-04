#!/bin/bash

# 1. Download and extract the stalker-to-m3u source code without git clone
# This avoids the "fatal: could not read Username" error.
curl -L -o stalker-to-m3u.zip https://github.com/JuanBindez/stalker-to-m3u/archive/refs/heads/master.zip
unzip stalker-to-m3u.zip
# The unzipped folder is "stalker-to-m3u-master". We rename it.
mv stalker-to-m3u-master stalker-to-m3u

# 2. Now change directory into the successfully created folder
cd stalker-to-m3u

# 3. Install dependencies
npm install

# 4. Create the config.json file directly on the runner
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

# 5. Use piping (echo -e "2\n1") to automate the interactive selections
./stalker-to-m3u categories
echo -e "2\n1" | ./stalker-to-m3u m3u --mode iptv

# 6. Move the generated file back to the main repository folder
mv iptv-mag.jee-ott.xyz.m3u ../iptv.m3u
cd ..

# 7. Commit and Push the updated file to GitHub
git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"
git add iptv.m3u
git commit -m "Automated playlist refresh $(date +%F)" || echo "No playlist changes to commit."
git push

