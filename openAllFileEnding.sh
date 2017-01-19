#!/usr/local/bin/bash

printf "\E[37;44m"

displayProgress(){
spinner="\|/-" # spinner
chars=1 # number of characters to display
delay=.1 # time in seconds between characters
prompt="press any key..." # user prompt
clearline="\e[K" # clear to end of line (ANSI terminal)
CR="\r"

#make cursor invisible
tput civis

while [[ true ]]; do # loop until user presses a key

	printf "thinking... "
	printf " %.${chars}s$CR" "$spinner" ##print first character of spinner then
	# carriage return to beginning of line
	temp=${spinner#?}               # remove first character from $spinner
	spinner=$temp${spinner%"$temp"} # and add it to the end
	sleep $delay

done
}

startCursor(){
	#start swiveling cursor in background
	displayProgress &
	#grab its PID so can kill later
	progress_pid=$!
	sleep 1
}

killCursor(){
	kill $progress_pid
	wait $progress_pid 2>/dev/null
	tput cnorm
}
#$# is number of arguments
if [[ $# == 0 ]]; then
	echo "Need one argument."
	exit
fi



#set the fileExtension variable to first argument
fileExtension="$1"
#array
filesArray=()

startCursor
#if user prematurely hits control c then we need to kill the cursor and then exit
trap 'killCursor; echo; exit' INT

#process substituion to find all files with the fileExtension
while read line; do
	#if the file is not a directory
	if [[ ! -d "$line" ]]; then
		#if the last characters of the filename after the . are the same as the first argument
		#then increment counter
		if [[ `echo "${line##*.}"` == "$fileExtension" ]]; then
			filesArray+=("$line")
		fi
	fi
#find all files in pwd that have the fileExtension in their names
done < <(find "`pwd`" -type f | grep -i "$fileExtension$")

killCursor

if (( ${#filesArray[@]} < 1 )); then
	echo "No files found with file extension: \"$fileExtension\""
	exit 25
else
	#echo the count of items in the array
	echo "We found ${#filesArray[@]} files."
fi

for file in "${filesArray[@]}"; do
	echo "$file"
done

printf "\E[1mDo want to open these files? \E[0m"
read -n1 

if [[ "$REPLY" == "y" ]]; then
	#loop through all files in array and open them
	for file in "${filesArray[@]}"; do
		open "$file"
	done
	
else
	#start prompt on next line
	echo
fi


printf "\E[0m"
