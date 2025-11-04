#!/bin/bash

# 1. Download and extract the stalker-to-m3u source code as a tarball.
# This avoids git credential errors and the broken zip file.
curl -L "https://github.com/JuanBindez/stalker-to-m3u/archive/refs/heads/master.tar.gz" | tar -xzf -

# 2. Change directory into the successfully created folder
# The tar command creates a folder named "stalker-to-m3u-master"
cd stalker-to-m3u-master

# 3. Install dependencies
npm install

# 4. Create the config.json file with your MAC/Portal details
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
# We use ../ to go up one level from 'stalker-to-m3u-master'
mv iptv-mag.jee-ott.xyz.m3u ../iptv.m3u
cd ..

# 7. Commit and Push the updated file to GitHub
git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"
git add iptv.m3u
git commit -m "Automated playlist refresh $(date +%F)" || echo "No playlist changes to commit."
git push

