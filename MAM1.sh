#!/bin/bash 

MAM='smb://videoteam:1EEmosc9I1mDtc0uyv4mbRjj25aTVsr7@{$IP_ADDRESS}/VIDEO_TEAM_ARCHIVE'
MAM_DIR='/Volumes/VIDEO_TEAM_ARCHIVE'
WEBHOOK_URL='https://hooks.slack.com/services/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'


read -p "Enter your username: " producer

DEST_DIR="/Volumes/VIDEO_TEAM_ARCHIVE/Producer Drives/${producer}"

#Is Storage Mounted?
if [[ ! -d $MAM_DIR ]]
then

echo "MAM is not mounted on local computer."
echo "Will now open MAM"
open $MAM

sleep 3
echo "You are now mounted to the MAM"

fi


#If storage IS mounted,and NO folder exists for producer then create producer folder on MAM server - ex. '/Volumes/VIDEO_TEAM_ARCHIVE/Producer Drives/mramirez'
#First Folder Check
if [[ ! -d $DEST_DIR ]]
then

echo "$producer was not found in MAM archives."

echo "Will now create folder for user ${producer} on VIDEO_TEAM_ARCHIVE..."

mkdir "$DEST_DIR" 

echo "$DEST_DIR was created."
fi 

#If producer folder DOES EXIST on MAM server, COPY FILES

echo "${producer} was found."

read -p "Please drag your harddrive filepath here: " source 

echo "SOURCE: ${source}" 
echo "DEST: ${DEST_DIR}" 

echo "Performing Rsync..."

rsync -av "$source" "$DEST_DIR" || curl --location --request POST $WEBHOOK_URL \
--header 'Content-Type: application/json' \
--data-raw '{
    "text": "'"The upload for ${producer} failed."'"
}'

