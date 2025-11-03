#!/bin/bash
cd stalker-to-m3u

# TV Playlist (Original MAC)
sed -i 's/"mac": ".*"/"mac": "00:1A:79:09:CB:D7"/' config.json
./stalker-to-m3u categories
./stalker-to-m3u m3u --mode iptv
mv iptv-mag.jee-ott.xyz.m3u ../iptv.m3u

# Phone Playlist (New Account MAC)
sed -i 's/"mac": ".*"/"mac": "00:1A:79:55:87:40"/' config.json
./stalker-to-m3u categories
./stalker-to-m3u m3u --mode iptv
mv iptv-mag.jee-ott.xyz.m3u ../phone-iptv.m3u

cd ..
git config --global user.email "bensmithgb53@gmail.com"
git config --global user.name "bensmithgb53"
git add iptv.m3u phone-iptv.m3u
git commit -m "Update both IPTV playlists $(date)"
git push origin main
