#!/usr/local/bin/bash
#created by JAKOBMENKE --> Sat Jan 14 18:12:20 EST 2017
DIR_WATCHING="$1"
while read -d "" event; do
	echo "The event was $event"
	bash $SCRIPTS/GitHelper.sh
done < <(fswatch -r -0 -E "$DIR_WATCHING" -e "/\.." )
