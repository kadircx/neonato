#!/usr/bin/env bash
# Copyright (c) 2024 The Neonato Authors and Kadir Celik. All rights reserved.
#
# This file protected under the MIT License (MIT).
# See LICENSE (in root directory) for more information.
#
# Written by Kadir Celik on 22.04.2024

set -euo pipefail
set +e

clear

echo "
 _   _                        _        
| \ | | ___  ___  _ __   __ _| |_ ___  
|  \| |/ _ \/ _ \| '_ \ / _\` | __/ _ \ 
| |\  |  __/ (_) | | | | (_| | || (_) |
|_| \_|\___|\___/|_| |_|\__,_|\__\___/ 

Experience a Sleeker MIUI with Neonato
"

# -----------------------------
# GLOBALS

readonly colors=(
    '\033[0;31m' # alert
    '\033[0;32m' # separator
    '\033[0;33m' # info
    '\033[0;34m' # main descriptions
)

readonly color_reset='\033[0m'

# Counter for successful and failed removals
success_count=0
fail_count=0

# -----------------------------
# DEFAULTS

remove_android_bloatwares=false
remove_google_bloatwares=false

# -----------------------------

# Check for `adb` (android-tools)
if ! command -v adb > /dev/null; then
    echo -e "${colors[0]}adb not found. Install android-tools and try again.${color_reset}"
    exit 1
fi

echo -e "${colors[3]}This script will remove all default MIUI apps by default.${color_reset}"
echo -e "${colors[3]}If you want to keep some of them, do not run this script or edit the script on Github.${color_reset}"
echo -e "${colors[3]}Github: https://github.com/kadircx/neonato${color_reset}"
echo -e "${colors[0]}Note: This action is irreversible and may affect your device's functionality.${color_reset}"
echo

read -rp "Remove Android bloatwares? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    remove_android_bloatwares=true
fi

read -rp "Remove Google bloatwares? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    remove_google_bloatwares=true
fi

echo -e "${colors[1]}Remove Android bloatwares: ${remove_android_bloatwares}${color_reset}"
echo -e "${colors[1]}Remove Google bloatwares: ${remove_google_bloatwares}${color_reset}"
read -rp "Continue with this settings? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 0
fi

miui_bloatwares=(
  "com.miui.health"
  "com.miui.compass"
  "com.miui.hybrid"
  "com.miui.hybrid.accessory"
  "com.miui.mishare.connetivity"
  "com.miui.mishare"
  "com.miui.msa.global"
  "com.miui.msa"
  "com.miui.nextpay"
  "com.miui.weather2"
  "com.miui.yellowpage"
  "com.xiaomi.glgm"
  "com.xiaomi.joyose"
  "com.xiaomi.location.fused"
  "com.xiaomi.midrop"
  "com.xiaomi.mipicks"
  "com.xiaomi.payment"
  "com.xiaomi.scanner"
  "com.autonavi.minimap"
  "in.amazon.mShop.android.shopping"
  "com.tencent.soter.soterserver"
)

google_bloatwares=(
  "com.google.android.apps.docs"
  "com.google.android.apps.maps"
  "com.google.android.apps.photos"
  "com.google.android.apps.tachyon"
  "com.google.android.apps.wellbeing"
  "com.google.android.gm"
  "com.google.android.gms"
  "com.google.android.gms.location.history"
  "com.google.android.marvin.talkback"
  "com.google.android.music"
  "com.google.android.videos"
  "com.google.android.youtube.music"
  "com.google.android.youtube"
  "com.google.ar.lens"
)

android_bloatwares=(
  "com.android.egg"
  "com.android.hotwordenrollment.okgoogle"
)

for bloatware in "${miui_bloatwares[@]}"; do
  echo "Removing: ${bloatware}"
  if adb shell pm uninstall -k --user 0 ${bloatware}; then
      ((success_count++))
  else
      ((fail_count++))
  fi
done

if [ "$remove_android_bloatwares" = true ]; then
  for bloatware in "${android_bloatwares[@]}"; do
    echo "Removing: ${bloatware}"
    if adb shell pm uninstall -k --user 0 ${bloatware}; then
        ((success_count++))
    else
        ((fail_count++))
    fi
  done
fi

if [ "$remove_google_bloatwares" = true ]; then
  for bloatware in "${google_bloatwares[@]}"; do
    echo "Removing: ${bloatware}"
    if adb shell pm uninstall -k --user 0 ${bloatware}; then
        ((success_count++))
    else
        ((fail_count++))
    fi
  done
fi

echo -e "${colors[2]}Successfully removed: ${success_count}${color_reset}"
echo -e "${colors[0]}Failed to remove: ${fail_count}${color_reset}"
echo "Done! Give us a star or contribute and add more bloatwares on Github: https://github.com/kadircx/neonato"
