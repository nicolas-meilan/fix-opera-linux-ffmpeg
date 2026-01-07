#!/bin/bash

# Run using sudo
if [[ $(whoami) != "root" ]]; then
  printf 'Error: Try to run it with sudo\n'
  exit 1
fi

# --- AUTOMATIC PATH DETECTION ---
printf '\nDetecting Opera installation path...\n'
# Getting the path where the actual libffmpeg.so resides
OPERA_BASE_DIR=$(dpkg -L opera-stable | grep 'libffmpeg.so' | xargs dirname 2>/dev/null)

if [ -z "$OPERA_BASE_DIR" ] || [ ! -d "$OPERA_BASE_DIR" ]; then
    OPERA_BASE_DIR=$(find /usr/lib/x86_64-linux-gnu /usr/lib -name "opera-stable" -type d | head -n 1)
fi

if [ -z "$OPERA_BASE_DIR" ]; then
    printf 'Error: Could not find Opera folder automatically.\n'
    exit 1
fi

readonly OPERA_FOLDER="${OPERA_BASE_DIR%/}/"
printf "Path detected: $OPERA_FOLDER\n"

# --- CONSTANTS ---
readonly TEMP_FOLDER='/tmp/opera_fix/'
readonly FILE_NAME='libffmpeg.so'
readonly ZIP_FILE='/tmp/opera_ffmpeg.zip'
readonly FFMPEG_URL='https://api.github.com/repos/Ld-Hagen/fix-opera-linux-ffmpeg-widevine/releases'

# --- DOWNLOAD PHASE ---
printf '\nGetting latest ffmpeg URL ...\n'
readonly DOWNLOAD_URL=$(wget -qO - $FFMPEG_URL | grep browser_download_url | cut -d '"' -f 4 | grep linux-x64 | head -n 1)

printf 'Downloading codec ...\n'
wget -q --show-progress $DOWNLOAD_URL -O "$ZIP_FILE"

printf 'Unzipping ...\n'
rm -rf "$TEMP_FOLDER"
mkdir -p "$TEMP_FOLDER"
unzip -q "$ZIP_FILE" -d "$TEMP_FOLDER"

# Locate the actual .so file in the temp folder
actual_lib=$(find "$TEMP_FOLDER" -name "$FILE_NAME" | head -n 1)

# --- INSTALLATION PHASE (Replacement with Backup) ---
printf "\nApplying fix in $OPERA_FOLDER ...\n"

# 1. Backup the original file if it's not a symlink already
if [ -f "${OPERA_FOLDER}${FILE_NAME}" ] && [ ! -L "${OPERA_FOLDER}${FILE_NAME}" ]; then
    printf "Creating backup of the original library...\n"
    mv "${OPERA_FOLDER}${FILE_NAME}" "${OPERA_FOLDER}${FILE_NAME}.bak"
fi

# 2. Copy the new library to the folder
cp -f "$actual_lib" "${OPERA_FOLDER}${FILE_NAME}"
chmod 644 "${OPERA_FOLDER}${FILE_NAME}"

# --- CLEANUP PHASE ---
printf '\nCleaning up temporary files ...\n'
rm -rf "$TEMP_FOLDER"
rm -f "$ZIP_FILE"

printf "\nDone! Opera is now using the patched libffmpeg.so.\n"
printf "Please restart your browser.\n"
