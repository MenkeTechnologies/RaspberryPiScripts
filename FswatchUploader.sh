#!/usr/local/bin/bash
#created by JAKOBMENKE --> Sat Jan 14 18:12:20 EST 2017 

#first argument is the directory to watch
#in quotes to account for spaces in directory name
DIR_WATCHING="$1"

#change for your system
IP=yourip
USER=loginname
WEB_DIR=/var/www/html
#this is the argument that will passed to scp
ADDRESS="$USER@$IP:$WEB_DIR"

#delimiter is \0 null character
while read -d "" event; do
	#the event should be the file that was changed, created or deleted.
	echo "The event was $event"
	
	echo "Uploading $event to $ADDRESS"
	#upload using scop
	scp -r "$event" "$ADDRESS" 2>/dev/null
	#using fswatch command, avaiable at https://github.com/emcrisostomo/fswatch,
	#r for recursive option, E for extended regex, e to exclude .git and .idea etc from triggering
	#watch service, 0 to use null \0 character as delimiter
done < <(fswatch -r -0 -E "$DIR_WATCHING" -e "/\.." )
