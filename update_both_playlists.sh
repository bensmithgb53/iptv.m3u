#!/bin/bash
cd stalker-to-m3u
npm install

# The 'm3u-iptv' script already calls 'pregroups', 'groups', and 'm3u'
# based on your package.json, ensuring correct compilation and execution.

# TV Playlist (MAC: 00:1A:79:09:CB:D7)
sed -i 's/"mac": ".*"/"mac": "00:1A:79:09:CB:D7"/' config.json
npm run m3u-iptv
mv iptv-mag.jee-ott.xyz.m3u ../iptv.m3u || echo "Failed to move TV playlist"

# Phone Playlist (MAC: 00:1A:79:55:87:40)
sed -i 's/"mac": ".*"/"mac": "00:1A:79:55:87:40"/' config.json
npm run m3u-iptv
mv iptv-mag.jee-ott.xyz.m3u ../phone-iptv.m3u || echo "Failed to move phone playlist"

cd ..
