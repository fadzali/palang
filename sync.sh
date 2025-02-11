#!/bin/bash

# FTP server A details (from which file will be downloaded)
SERVER_A="10.x.x.x"
USER_A="changeme"
PASS_A="changeme"
REMOTE_PATH_A="filename.txt"

# FTP server B details (to which file will be uploaded)

SERVER_B="10.x.x.x"
USER_B="changeme"
PASS_B="changeme"
REMOTE_PATH_B="/dir/path/filename.txt"

# Local file path to store downloaded file temporarily
TEMP_FILE="/tmp/temp_file/filename.txt"

# Download from Server A using lftp
echo "Connecting to Server A and downloading the file..."
lftp -e "
open $SERVER_A
user $USER_A $PASS_A
get $REMOTE_PATH_A -o $TEMP_FILE
bye
" -u $USER_A,$PASS_A

if [ $? -ne 0 ]; then
  echo "Error: FTP download from Server A failed."
  exit 1
fi
# Remove lines starting with 'USM'

echo "Cleaning file: Removing lines starting with 'USM'..."
sed -i '/^[Uu][Ss][Mm]/d' "$TEMP_FILE"
echo "Cleaning complete."

# Upload to Server B using lftp
echo "Connecting to Server B and uploading the file..."
lftp -e "
open $SERVER_B
user $USER_B $PASS_B
put $TEMP_FILE -o $REMOTE_PATH_B
bye
" -u $USER_B,$PASS_B

if [ $? -ne 0 ]; then
  echo "Error: FTP upload to Server B failed."
  exit 1
fi

# Clean up: Remove the temporary file
rm -f $TEMP_FILE

echo "File successfully transferred from Server A to Server B."

