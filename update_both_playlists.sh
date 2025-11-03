#!/bin/bash
cd stalker-to-m3u
if [ ! -f package.json ]; then
  echo "Error: package.json not found in stalker-to-m3u"
  exit 1
fi
npm install
chmod +x stalker-to-m3u

# TV Playlist
sed -i 's/"mac": ".*"/"mac": "00:1A:79:09:CB:D7"/' config.json
npx ts-node generate-groups.ts --mode iptv
npx ts-node generate-m3u.ts --mode iptv
mv iptv-mag.jee-ott.xyz.m3u ../iptv.m3u || echo "Failed to move TV playlist"

# Phone Playlist
sed -i 's/"mac": ".*"/"mac": "00:1A:79:55:87:40"/' config.json
npx ts-node generate-groups.ts --mode iptv
npx ts-node generate-m3u.ts --mode iptv
mv iptv-mag.jee-ott.xyz.m3u ../phone-iptv.m3u || echo "Failed to move phone playlist"

cd ..
git config --global user.email "bensmithgb53@gmail.com"
git config --global user.name "bensmithgb53"
git add iptv.m3u phone-iptv.m3u
git commit -m "Update both IPTV playlists $(date)" || true
git push https://bensmithgb53:${PERSONAL_ACCESS_TOKEN}@github.com/bensmithgb53/iptv.m3u.git
