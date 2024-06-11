#!/bin/bash


ADB="adb"
THEME_STORE_PKG="com.heytap.themestore"
NEARME_THEME_STORE_PKG="com.nearme.themestore"


check_and_convert_trial_status() {
  local setting_name="$1"
  local display_name="$2"
  local uuid_setting="$3"

  adb shell settings get system "$setting_name" >tempfile.tmp
  local status=$(<tempfile.tmp)

  if [ "$status" -ne 0 ]; then
    echo "$display_name Status: Trial"
    adb shell settings put system "$uuid_setting" -1
    adb shell settings put secure "$uuid_setting" -1
    adb shell settings put system "$setting_name" 0
    adb shell settings put secure "$setting_name" 0
    echo "Successfully converted to permanent."
  else
    echo "$display_name Status: Permanent"
  fi
}


main() {
  echo "******************************************"
  echo "*    OPPO/OnePlus/Realme Theme Wizard    *"
  echo "*      ----------------------------      *"
  echo "*                        by @ImKKingshuk *"
  echo "* Github- https://github.com/ImKKingshuk *"
  echo "******************************************"
  echo


  


  $ADB shell am force-stop "$THEME_STORE_PKG"
  $ADB shell am force-stop "$NEARME_THEME_STORE_PKG"

  echo


  check_and_convert_trial_status "persist.sys.trial.theme" "Theme" "persist.sys.oppo.theme_uuid"
  check_and_convert_trial_status "persist.sys.trial.font" "Font" "persist.sys.trial.font"
  check_and_convert_trial_status "persist.sys.trial.live_wp" "Live Wallpaper" "persist.sys.trial.live_wp_uuid"

 
  rm -f tempfile.tmp
  $ADB kill-server
}


main
