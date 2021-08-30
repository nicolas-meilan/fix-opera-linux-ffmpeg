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
readonly WIDEVINE_FOLDER='/opt/google/chrome/WidevineCdm'

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

if test -d $WIDEVINE_FOLDER
        then
                rm -rf "$OPERA_FOLDER/lib_extra"
                mkdir "$OPERA_FOLDER/lib_extra"
                cp -R $WIDEVINE_FOLDER "$OPERA_FOLDER/lib_extra/"
                printf "[\n      {\n         "preload": "/usr/lib/x86_64-linux-gnu/opera/lib_extra/WidevineCdm"\n      }\n]\n" > "$OPERA_FOLDER/resources/widevine_config.json"
        else
                printf "There should be Google Chrome installed to /opt/google/chrome to use its WidevineCdm\n"
                exit 1
fi
