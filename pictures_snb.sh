#!/bin/bash
clear
date +"%m/%d/%Y %H:%M:%S $HOSTNAME" >> /home/ron/condoc/time.tmp
# Picture sync and backup
# Phase 1 rsyncs the Pictures folder from LAN
# Phase 2 rsyncs the smaller Lightroom Catalogue folders a second time to a different drive altogether thereby creating two copies. Three total including the original source. 
echo
echo Initiating rsync from MEGALOPOLIS to ZFS 'backup_pool'
echo
sudo rsync -avz --compress-level=9 --progress -e ssh /media/LAN_Pictures/ /media/backup_pool/pictures_backup/
echo
echo Syncing secondary Lightroom Catalog - Initiating rsync from /media/backup_pool/LAN_Picutres/Lighroom/ to /media/nu_storage/Lig?*
echo
sudo rsync -avz --compress-level=9 --progress -e ssh /media/backup_pool/pictures_backup/Lightroom/ /media/nu_storage/Lightroom_cat_backup/Lightroom/
echo
echo RSYNC operations completed from megalopolis to backup_pool
echo
echo Stand by, files are being counted...
echo
cd "/media/LAN_Pictures/"
# Number of files seen on megalopolis with output redirected to a new file. (append starts with line 1 if doc is blank)
find .//. ! -name . -print | grep -c // >> /home/ron/condoc/rstxt.tmx
cd "/media/backup_pool/pictures_backup/"
echo
# Number of files seen in pictures_backup on ZFS backup_pool. Output will become the second line in the rstxt.tmx text file.
find .//. ! -name . -print | grep -c // >> /home/ron/condoc/rstxt.tmx
cd /home/ron/condoc/
echo
echo Number of files seen on megalopolis: 
echo
# Reading only the first line of the text file
sed -n 1p rstxt.tmx
echo
echo Number of files seen in pictures_backup on ZFS backup_pool:
echo
# disregard next line, science project for text positioning to be fixed with python.
# tput cup 40 40
# Read the second line from the txt file
sed -n 2p rstxt.tmx
echo
# Delete the temp file; whose got time for logs?
rm /home/ron/condoc/rstxt.tmx
echo Script start time:
echo
# read a line from another temporary text file created earlier in this script
sed -n 1p  /home/ron/condoc/time.tmp
# delete the temporary text file with the odd .tmp extension
rm /home/ron/condoc/time.tmp
echo
echo Script end time:
echo
# unnecessary but fun date syntax
date +"%m/%d/%Y %H:%M:%S $HOSTNAME"
echo

# END SCRIPT

# LINKS http://unix.stackexchange.com/questions/52313/how-to-get-execution-time-of-a-script-effectively text position
# http://stackoverflow.com/questions/20381937/bash-text-absolute-positioning/20385064#20385064
# 
echo
