#!/usr/local/bin/bash
#created by JAKOBMENKE --> Sat Jan 14 18:12:20 EST 2017

DIR_WATCHING="$1"
IP=yourip
USER=loginname
WEB_DIR=/var/www/html
ADDRESS="$USER@$IP:$WEB_DIR"

while read -d "" event; do
	echo "The event was $event"
	echo -e "${BLUE}Uploading $event to $ADDRESS"
	scp -r "$event" "$ADDRESS" 2>/dev/null


done < <(fswatch -r -0 -E "$DIR_WATCHING" -e "/\.." )