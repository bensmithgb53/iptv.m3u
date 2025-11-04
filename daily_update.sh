#!/bin/bash

cd stalker-to-m3u

# 1. Install dependencies to ensure tsc can find modules and type definitions.
npm install 

# 2. Run the playlist generation using the robust 'npm run start-iptv' command
# This uses the official package scripts, which handles all TS-to-JS compilation steps.
npm run start-iptv

# The output file name is fixed by the package script, so we move it
mv iptv-mag.jee-ott.xyz.m3u ../iptv.m3u

# 3. Commit and Push the updated file to GitHub
cd ../
git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"
git add iptv.m3u
git commit -m "Automated playlist refresh $(date +%F)" || echo "No playlist changes to commit."
git push

