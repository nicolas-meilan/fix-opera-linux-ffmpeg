#!/bin/bash

# Run using sudo
if [[ $(whoami) != "root" ]]; then
  printf 'Try to run it with sudo\n'
  exit 1
fi

readonly TEMP_FOLDER='/tmp/'
readonly OPERA_FOLDER='/usr/lib/x86_64-linux-gnu/opera/'
readonly FILE_NAME='libffmpeg.so'
readonly ZIP_FILE='.zip'
readonly TEMP_FILE="$TEMP_FOLDER$FILE_NAME"
readonly OPERA_FILE="$OPERA_FOLDER$FILE_NAME"
readonly FIX_WIDEVINE=true
readonly CHROME_DL_LINK="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

readonly GIT_API=https://api.github.com/repos/iteufel/nwjs-ffmpeg-prebuilt/releases

printf '\nGetting Url ...\n'

readonly OPERA_FFMPEG_URL=$(curl -s $GIT_API | grep browser_download_url | cut -d '"' -f 4 | grep linux-x64 | head -n 1)

printf '\nDownloading ffmpeg ...\n'

wget $OPERA_FFMPEG_URL -O "$TEMP_FILE$ZIP_FILE"

printf "\nUnzipping ...\n\n"

unzip "$TEMP_FILE$ZIP_FILE" -d $TEMP_FILE

printf "\nMoving file on $OPERA_FILE ...\n"

mv -f "$TEMP_FILE/$FILE_NAME" $OPERA_FILE

printf '\nDeleting Temporary files ...\n'

find $TEMP_FOLDER -name "*$FILE_NAME*" -delete

if $FIX_WIDEVINE
  then
    rm -rf "$OPERA_FOLDER/lib_extra"
    mkdir "$OPERA_FOLDER/lib_extra"
    printf  "\nDownloading Google Chrome ...\n"
    wget -P "$TEMP_FOLDER" "$CHROME_DL_LINK"

    printf "\nExtracting Chrome to temporary folder ...\n"
    CHROME_PKG_NAME=`basename $CHROME_DL_LINK`
    dpkg -x "$TEMP_FOLDER/$CHROME_PKG_NAME" "$TEMP_FOLDER/chrome"

    printf "\nInstalling WidevineCdm ...\n"
    cp -R "$TEMP_FOLDER/chrome/opt/google/chrome/WidevineCdm" "$OPERA_FOLDER/lib_extra/"
    printf "[\n      {\n         \"preload\": \"$OPERA_FOLDER/lib_extra/WidevineCdm\"\n      }\n]\n" > "$OPERA_FOLDER/resources/widevine_config.json"

    printf "\nDeleting temprorary files ...\n"
    rm -rf "$TEMP_FOLDER/chrome"
  else
    printf "\nInstalling WidevineCdm skipped\n"
fi
