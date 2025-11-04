#!/bin/bash

cd stalker-to-m3u

# 1. Run the playlist generation
echo -e "2\n1" | ./stalker-to-m3u m3u --mode iptv

# 2. Move the file up to the main repo directory
mv iptv-mag.jee-ott.xyz.m3u ../iptv.m3u

# 3. Commit and Push the updated file to GitHub
cd ../
git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"
git add iptv.m3u
git commit -m "Automated playlist refresh $(date +%F)" || echo "No playlist changes to commit."
git push
