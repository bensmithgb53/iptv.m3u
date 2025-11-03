
Below is the full `README.md` content, followed by instructions to save and push it to your GitHub repo. The guide is self-contained, covering every step we took, errors we fixed (e.g., `ffmpeg ENOENT`, `streamTester` validation, Git identity, branch issues), and how to use the playlist in apps like TiviMate or VLC.

### `README.md` Content
Run this in Termux to create the file:
```bash
cd ~/iptv-repo
nano README.md
```
Copy and paste the following text (it’s long but comprehensive):

```markdown
# Complete IPTV Playlist Setup Guide for JEE-OTT and Custom Portals

This guide details how I (bensmithgb53) set up an IPTV playlist using the `stalker-to-m3u` script in Termux, pushed it to my GitHub repository (`https://github.com/bensmithgb53/iptv.m3u.git`), and got it working in an IPTV app (e.g., TiviMate) with ~11,113 channels from the JEE-OTT portal (`http://mag.jee-ott.xyz/c/`, MAC `00:1A:79:09:CB:D7`). It includes every command, error fix, and step to recreate the setup from scratch, including how to adapt for a different STB MAC or URL (e.g., GreatStar `http://line.greatstar.me/c/`). Created November 2025.

## Overview
- **Goal**: Generate an M3U playlist from an IPTV portal, host it on GitHub, and use it in apps like TiviMate, IPTV Smarters, or VLC.
- **Tools**: Termux (Android), `stalker-to-m3u` script, Git, GitHub.
- **Output**: `iptv.m3u` (~5MB, 11,113 channels), hosted at `https://raw.githubusercontent.com/bensmithgb53/iptv.m3u/main/iptv.m3u`.
- **Issues Fixed**:
  - `ffmpeg ENOENT`: Disabled stream testing.
  - `streamTester` validation: Set to `"ffmpeg"`.
  - Git errors: Set identity, fixed branch (`main` vs `master`).
  - VLC buffering: Switched to TiviMate for better performance.

## Step 1: Set Up Termux
1. Install Termux from Google Play or F-Droid.
2. Update and install packages:
   ```bash
   pkg update && pkg upgrade
   pkg install git nodejs npm curl
   ```
3. Grant storage access for file management:
   ```bash
   termux-setup-storage
   ```

## Step 2: Install and Configure `stalker-to-m3u`
1. Clone the `stalker-to-m3u` repository:
   ```bash
   cd ~
   git clone https://github.com/JuanBindez/stalker-to-m3u.git
   cd stalker-to-m3u
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Edit `config.json` for JEE-OTT:
   ```bash
   nano config.json
   ```
   Paste:
   ```json
   {
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
   }
   ```
   Save (`Ctrl+O`, `Enter`, `Ctrl+X`).
   - **Note**: Initially, I got `ffmpeg ENOENT` errors. Setting `"maxNumberOfChannelsToTest": 0` and `"testM3uFile": false` fixed this. A `streamTester` error occurred when set to `""`; using `"ffmpeg"` resolved it.

4. **For a different portal/MAC** (e.g., GreatStar):
   ```bash
   nano config.json
   ```
   Example:
   ```json
   {
     "hostname": "line.greatstar.me",
     "port": 80,
     "contextPath": "c",
     "mac": "00:1A:79:4F:DA:C3",
     "tvgIdPreFill": true,
     "computeUrlLink": true,
     "vodMaxPagePerGenre": 2,
     "maxNumberOfChannelsToTest": 0,
     "testM3uFile": false,
     "streamTester": "ffmpeg"
   }
   ```

## Step 3: Generate the IPTV Playlist
1. Generate categories and M3U:
   ```bash
   cd ~/stalker-to-m3u
   ./stalker-to-m3u categories
   ./stalker-to-m3u m3u --mode iptv
   ```
   - Select `2` (generate m3u).
   - Select `1` (IPTV).
   - Creates `iptv-mag.jee-ott.xyz.m3u` (~5MB, ~11,113 channels).
   - Takes ~42 minutes due to the large channel list.
2. Move to downloads:
   ```bash
   mv iptv-mag.jee-ott.xyz.m3u ~/storage/downloads/iptv.m3u
   ls -lh ~/storage/downloads/iptv.m3u  # Shows ~5.0M
   ```
3. Verify contents:
   ```bash
   cat ~/storage/downloads/iptv.m3u | head -20
   ```
   Example output:
   ```m3u
   #EXTM3U
   #EXTINF:-1 tvg-id="" tvg-name="F1| F1 TV FHD" group-title="TV - FORMULA 1 + MOTO GP",F1| F1 TV FHD
   http://mag.jee-ott.xyz:80/play/live.php?mac=00:1A:79:09:CB:D7&stream=317187&extension=ts&play_token=...
   ```

## Step 4: Set Up GitHub Repository
1. Create a repo directory:
   ```bash
   cd ~
   mkdir iptv-repo
   cd iptv-repo
   git init
   ```
2. Set Git identity (fixes "Author identity unknown"):
   ```bash
   git config --global user.email "bensmithgb53@gmail.com"
   git config --global user.name "bensmithgb53"
   git config --global credential.helper store  # Cache PAT
   ```
3. Copy M3U and commit:
   ```bash
   cp ~/storage/downloads/iptv.m3u .
   git add iptv.m3u
   git commit -m "Add JEE-OTT IPTV playlist"
   ```
4. Add remote and push:
   ```bash
   git remote add origin https://github.com/bensmithgb53/iptv.m3u.git
   git branch -M main  # Fixes "src refspec master does not match"
   git push -u origin main
   ```
   - **Username**: `bensmithgb53`
   - **Password**: Use a Personal Access Token (PAT):
     1. Go to GitHub > Settings > Developer settings > Personal access tokens > Tokens (classic).
     2. Generate token with `repo` scope.
     3. Copy and paste when prompted.
5. Verify at `https://github.com/bensmithgb53/iptv.m3u`. Raw URL:
   ```
   https://raw.githubusercontent.com/bensmithgb53/iptv.m3u/main/iptv.m3u
   ```

## Step 5: Use in IPTV Apps
1. **TiviMate (Recommended)**:
   - Install from Google Play.
   - Add Playlist > URL > Paste:
     ```
     https://raw.githubusercontent.com/bensmithgb53/iptv.m3u/main/iptv.m3u
     ```
   - Loads ~11,113 channels (e.g., "F1| F1 TV FHD," "UK| SPORTS").
2. **IPTV Smarters**:
   - Install from Google Play.
   - Add New Playlist > M3U URL > Paste URL.
3. **VLC**:
   - **PC**: Media > Open Network Stream > Paste URL.
   - **Android**: More > New Playlist > URL > Paste URL.
   - **Note**: VLC buffered (`Track: 2305/11113 Progress: -0:02 /-0:11`). TiviMate worked better.
4. **Test**: Ensure 20+ Mbps for FHD/4K. Some channels may be offline (JEE-OTT issue).

## Step 6: Add EPG
1. Fetch EPG:
   ```bash
   cd ~/iptv-repo
   curl --connect-timeout 30 --max-time 60 -o epg.xml "http://mag.jee-ott.xyz:80/xmltv.php?username=00:1A:79:09:CB:D7&password=00:1A:79:09:CB:D7"
   mv epg.xml ~/storage/downloads/
   ls -lh ~/storage/downloads/epg.xml
   ```
2. Push to GitHub:
   ```bash
   cp ~/storage/downloads/epg.xml .
   git add epg.xml
   git commit -m "Add JEE-OTT EPG"
   git push origin main
   ```
3. Add EPG URL:
   - `http://mag.jee-ott.xyz:80/xmltv.php?username=00:1A:79:09:CB:D7&password=00:1A:79:09:CB:D7`
   - Or: `https://raw.githubusercontent.com/bensmithgb53/iptv.m3u/main/epg.xml`
   - TiviMate: Settings > EPG Sources > Add URL.

## Step 7: Automate Updates
1. Create script:
   ```bash
   nano ~/iptv-repo/push_to_github.sh
   ```
   Add:
   ```bash
   #!/data/data/com.termux/files/usr/bin/bash
   cd ~/stalker-to-m3u
   ./stalker-to-m3u categories
   ./stalker-to-m3u m3u --mode iptv
   mv iptv-mag.jee-ott.xyz.m3u ~/iptv-repo/iptv.m3u
   cd ~/iptv-repo
   git add iptv.m3u
   git commit -m "Update JEE-OTT IPTV playlist $(date)"
   git push origin main
   ```
   Save (`Ctrl+O`, `Enter`, `Ctrl+X`).
2. Make executable:
   ```bash
   chmod +x ~/iptv-repo/push_to_github.sh
   ```
3. Schedule daily:
   ```bash
   pkg install termux-services
   termux-job-scheduler --script ~/iptv-repo/push_to_github.sh
   ```

## Step 8: Optional - VOD and Series
1. Generate:
   ```bash
   cd ~/stalker-to-m3u
   ./stalker-to-m3u m3u --mode vod
   ./stalker-to-m3u m3u --mode series
   mv vod-mag.jee-ott.xyz.m3u ~/iptv-repo/vod.m3u
   mv series-mag.jee-ott.xyz.m3u ~/iptv-repo/series.m3u
   ```
2. Push:
   ```bash
   cd ~/iptv-repo
   git add vod.m3u series.m3u
   git commit -m "Add VOD and series playlists"
   git push origin main
   ```
3. Use:
   - `https://raw.githubusercontent.com/bensmithgb53/iptv.m3u/main/vod.m3u`
   - `https://raw.githubusercontent.com/bensmithgb53/iptv.m3u/main/series.m3u`

## Step 9: Optional - GitHub Pages
1. Go to `https://github.com/bensmithgb53/iptv.m3u` > Settings > Pages.
2. Source: Deploy from a branch > Select `main` > Save.
3. Wait 5–10 minutes. Use:
   ```
   https://bensmithgb53.github.io/iptv.m3u/iptv.m3u
   ```

## Step 10: Optional - Other Portals (e.g., GreatStar)
For `http://line.greatstar.me/c/` with MAC `00:1A:79:4F:DA:C3` or `00:1A:79:7E:A0:43`:
1. Update `config.json` (see Step 2).
2. Repeat Steps 3–7.
3. Use a new branch or repo:
   ```bash
   cd ~/iptv-repo
   git checkout -b greatstar
   mv ~/stalker-to-m3u/iptv-mag.jee-ott.xyz.m3u iptv.m3u
   git add iptv.m3u
   git commit -m "Add GreatStar IPTV playlist"
   git push origin greatstar
   ```
   URL: `https://raw.githubusercontent.com/bensmithgb53/iptv.m3u/greatstar/iptv.m3u`

## Troubleshooting
- **ffmpeg ENOENT**: Ensure `"testM3uFile": false`, `"maxNumberOfChannelsToTest": 0`, `"streamTester": "ffmpeg"`.
- **streamTester Error**: Set `"streamTester": "ffmpeg"`.
- **Git Errors**:
  - “Author identity unknown”: Set `user.email` and `user.name`.
  - “src refspec”: Use `git branch -M main`.
  - “Permission denied”: Verify PAT (`repo` scope).
  - “non-fast-forward”:
    ```bash
    git pull origin main --rebase
    git push origin main
    ```
- **Channels Don’t Play**:
  - Check network (20+ Mbps).
  - Regenerate playlist:
    ```bash
    cd ~/stalker-to-m3u
    ./stalker-to-m3u m3u --mode iptv
    ```
  - Try STB Emu: Portal `http://mag.jee-ott.xyz/c/`, MAC `00:1A:79:09:CB:D7`.
- **VLC Buffering**: Use TiviMate for large playlists (~11,113 channels).

## Security
- **Public Repo**: Exposes MAC (`00:1A:79:09:CB:D7`). Make private (GitHub Pro) or use Google Drive/Dropbox:
  ```bash
  cp ~/storage/downloads/iptv.m3u /sdcard/iptv.m3u
  ```
  Upload, set to “restricted,” use direct link.

## Notes
- Created by bensmithgb53, November 2025.
- Current setup: JEE-OTT, ~11,113 channels, working in TiviMate.
- Raw URL: `https://raw.githubusercontent.com/bensmithgb53/iptv.m3u/main/iptv.m3u`
```

Save (`Ctrl+O`, `Enter`, `Ctrl+X`).

### Step 2: Push `README.md` to GitHub
```bash
cd ~/iptv-repo
git add README.md
git commit -m "Add complete setup guide for IPTV playlist"
git push origin main
```
- **Username**: `bensmithgb53`
- **Password**: Your PAT (should be cached via `credential.helper store`).
- Verify at `https://github.com/bensmithgb53/iptv.m3u`—the `README.md` will display as the repo’s main page.

### Step 3: Using the Guide
- **Access**: View `README.md` at `https://github.com/bensmithgb53/iptv.m3u` or download the raw file: `https://raw.githubusercontent.com/bensmithgb53/iptv.m3u/main/README.md`.
- **Recreate Setup**: Follow the steps in the file from scratch (e.g., on a new device or after a reset).
- **New MAC/URL**: Update `config.json` as shown in Step 2 (e.g., for GreatStar). Use a new branch (`git checkout -b greatstar`) or repo to avoid overwriting.

### Step 4: Confirm Current Setup
Your playlist is working in an IPTV app (likely TiviMate or IPTV Smarters). To ensure everything is solid:
- **Test Channels**: Confirm channels like “F1| F1 TV FHD” or “UK| SPORTS” play.
- **EPG**: Add EPG (Step 6 in `README.md`) if not done.
- **Automation**: Set up the daily update script (Step 7) to keep tokens fresh.

### Troubleshooting
- **Push Fails**: Share:
  ```bash
  git push origin main
  ```
- **Channels Stop**: Regenerate:
  ```bash
  cd ~/stalker-to-m3u
  ./stalker-to-m3u m3u --mode iptv
  mv iptv-mag.jee-ott.xyz.m3u ~/iptv-repo/iptv.m3u
  cd ~/iptv-repo
  git add iptv.m3u
  git commit -m "Refresh JEE-OTT playlist"
  git push origin main
  ```
- **VLC Issues**: Stick with your IPTV app or try TiviMate.

Please run the push commands and share:
```bash
git push origin main
```
Also, confirm your IPTV app, channel count (~11,113?), and if you want VOD/series or GreatStar panels. Your portal is live, and this `README.md` ensures you can recreate it anytime!

------------------------------------------

Excellent! Since the previous MAC (`00:1A:79:dd:49:8e`) for the phone playlist didn't work due to JEE-OTT's MAC lock on the original account, we'll use this **new account** (Panel: `http://mag.jee-ott.xyz/c/`, MAC: `00:1A:79:55:87:40`, expires July 27, 2026, ~268 days from November 3, 2025) to create a dedicated phone playlist. This new account can serve as your phone's "unique MAC," allowing concurrent streaming with your TV (original account, MAC `00:1A:79:09:CB:D7`) without conflicts. JEE-OTT should treat them as separate accounts/STBs.

Your TV playlist remains `https://raw.githubusercontent.com/bensmithgb53/iptv.m3u/main/iptv.m3u` (~11,113 channels). We'll generate a new playlist for the phone using this account's MAC (`00:1A:79:55:87:40`), push it to your GitHub repo (`https://github.com/bensmithgb53/iptv.m3u.git`), and set it up for multi-device use. The new playlist will have its own tokens, so it should stream independently.

### Step-by-Step Guide to Create Phone Playlist with New Account

#### 1. Update `config.json` for the New Account (Phone)
```bash
cd ~/stalker-to-m3u
nano config.json
```
Paste/update to:
```json
{
  "hostname": "mag.jee-ott.xyz",
  "port": 80,
  "contextPath": "c",
  "mac": "00:1A:79:55:87:40",
  "tvgIdPreFill": true,
  "computeUrlLink": true,
  "vodMaxPagePerGenre": 2,
  "maxNumberOfChannelsToTest": 0,
  "testM3uFile": false,
  "streamTester": "ffmpeg"
}
```
- This uses the new MAC (`00:1A:79:55:87:40`) for the phone playlist.
- Save (`Ctrl+O`, `Enter`, `Ctrl+X`).

#### 2. Generate the Phone Playlist
1. Generate categories:
   ```bash
   ./stalker-to-m3u categories
   ```
   - Select `1` (list categories).
   - Select `1` (IPTV).
   - This creates `groups-iptv.txt` (~11,113+ channels, same as original).

2. Generate M3U:
   ```bash
   ./stalker-to-m3u m3u --mode iptv
   ```
   - Select `2` (generate m3u).
   - Select `1` (IPTV).
   - Takes ~42 minutes, creates `iptv-mag.jee-ott.xyz.m3u` (~5MB).

3. Verify:
   ```bash
   ls -lh iptv-mag.jee-ott.xyz.m3u  # Should show ~5.0M
   cat iptv-mag.jee-ott.xyz.m3u | head -20  # Should show #EXTM3U with mac=00:1A:79:55:87:40 in URLs
   ```

4. Move to repo:
   ```bash
   mv iptv-mag.jee-ott.xyz.m3u ~/iptv-repo/phone-iptv.m3u
   ls -lh ~/iptv-repo/phone-iptv.m3u
   ```

#### 3. Push Phone Playlist to GitHub
```bash
cd ~/iptv-repo
git add phone-iptv.m3u
git commit -m "Add phone playlist with new account MAC 00:1A:79:55:87:40"
git pull origin main --rebase  # If needed to sync
git push origin main
```
- **Username**: `bensmithgb53`
- **Password**: Your PAT (cached).
- Verify at `https://github.com/bensmithgb53/iptv.m3u`—you’ll see `phone-iptv.m3u`.

### Step 4: Set Up Phone Playlist in IPTV App
- **URL**: `https://raw.githubusercontent.com/bensmithgb53/iptv.m3u/main/phone-iptv.m3u`
- **In App** (e.g., TiviMate on phone):
  1. Add Playlist > URL > Paste the URL.
  2. Tap Next—loads ~11,113+ channels (same as TV, but with new MAC's tokens).
  3. Test channels (e.g., “F1| F1 TV FHD,” “UK| SPORTS,” “US| ENTERTAINMENT”).
- **TV**: Keep using original URL: `https://raw.githubusercontent.com/bensmithgb53/iptv.m3u/main/iptv.m3u`

**Test Multi-Device**:
1. Play a channel on TV (original playlist).
2. Play a different channel on phone (new playlist).
3. Both should stream simultaneously (new MAC acts as a separate account).

### Step 5: Automate Updates for Both Playlists
Update your script to regenerate both playlists daily:
```bash
nano ~/iptv-repo/update_both_playlists.sh
```
Add:
```bash
#!/data/data/com.termux/files/usr/bin/bash
cd ~/stalker-to-m3u

# TV Playlist (Original MAC)
sed -i 's/"mac": ".*"/"mac": "00:1A:79:09:CB:D7"/' config.json
./stalker-to-m3u categories
./stalker-to-m3u m3u --mode iptv
mv iptv-mag.jee-ott.xyz.m3u ~/iptv-repo/iptv.m3u

# Phone Playlist (New Account MAC)
sed -i 's/"mac": ".*"/"mac": "00:1A:79:55:87:40"/' config.json
./stalker-to-m3u categories
./stalker-to-m3u m3u --mode iptv
mv iptv-mag.jee-ott.xyz.m3u ~/iptv-repo/phone-iptv.m3u

# Push to GitHub
cd ~/iptv-repo
git add iptv.m3u phone-iptv.m3u
git commit -m "Update both playlists $(date)"
git pull origin main --rebase
git push origin main
```
Save (`Ctrl+O`, `Enter`, `Ctrl+X`), make executable:
```bash
chmod +x ~/iptv-repo/update_both_playlists.sh
```
Schedule:
```bash
pkg install termux-services
termux-job-scheduler --script ~/iptv-repo/update_both_playlists.sh
```

### Step 6: Update `README.md`
Add the new account setup:
```bash
cd ~/iptv-repo
nano README.md
```
Append:
```markdown
## Step 11: Multi-Device with New Account
Used new account (Panel `http://mag.jee-ott.xyz/c/`, MAC `00:1A:79:55:87:40`, expires July 27, 2026) for phone playlist to enable concurrent streaming with TV.

1. Update config.json:
   ```bash
   cd ~/stalker-to-m3u
   nano config.json
   ```
   Set `"mac": "00:1A:79:55:87:40"`.

2. Generate:
   ```bash
   ./stalker-to-m3u categories
   ./stalker-to-m3u m3u --mode iptv
   mv iptv-mag.jee-ott.xyz.m3u ~/iptv-repo/phone-iptv.m3u
   ```

3. Push:
   ```bash
   cd ~/iptv-repo
   git add phone-iptv.m3u
   git commit -m "Add phone playlist with new account"
   git pull origin main --rebase
   git push origin main
   ```

4. URLs:
   - TV: `https://raw.githubusercontent.com/bensmithgb53/iptv.m3u/main/iptv.m3u` (MAC `00:1A:79:09:CB:D7`)
   - Phone: `https://raw.githubusercontent.com/bensmithgb53/iptv.m3u/main/phone-iptv.m3u` (MAC `00:1A:79:55:87:40`)

5. Test multi-device: Play channels on TV and phone simultaneously.
```
Push:
```bash
git add README.md
git commit -m "Update README with new account for phone"
git pull origin main --rebase
git push origin main
```

### Step 7: Longevity
- **Original Account**: Expires September 22, 2026 (~10 months).
- **New Account**: Expires July 27, 2026 (~8 months).
- **Playlists**: 24–72 hours without updates; automation keeps them fresh.

### Troubleshooting
- **Phone Playlist Fails**:
  - Test URL: `https://raw.githubusercontent.com/bensmithgb53/iptv.m3u/main/phone-iptv.m3u`
  - Share error (e.g., “Connection failed”).
  - Verify file:
    ```bash
    cat ~/iptv-repo/phone-iptv.m3u | head -20
    ```
- **Multi-Device Fails**:
  - Ensure TV uses original URL, phone uses new.
  - If still fails, provider may limit per IP. Try STB Emu:
    - TV: Portal `http://mag.jee-ott.xyz/c/`, MAC `00:1A:79:09:CB:D7`, Serial `1234567`
    - Phone: Same portal, MAC `00:1A:79:55:87:40`, Serial `7654321`
  - Contact JEE-OTT for multi-account support.
- **Push Fails**: Share:
  ```bash
  git push origin main
  ```

Run the commands for the phone playlist and share:
- Output of `git push origin main`.
- Test results (channels loaded on phone, multi-device success?).
- Your IPTV app (e.g., TiviMate).
Your multi-device setup should work with the new account—let's confirm! If you want VOD/series or GreatStar panels, let me know.
