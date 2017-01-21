#!/usr/local/bin/bash
#created by JAKOBMENKE --> Fri Jan 20 16:24:16 EST 2017

executableScriptsProcessing(){
	# then make it executable
	chmod 700 "$newfile"
	#add header
	echo "#created by JAKOBMENKE --> `date` " >> "$newfile"
	#and open file
	open -t "$newfile"
	#run python3 script with pyautogi commands for keyboard shortcuts
	python3 /Users/jacobmenke/PycharmProjects/textEditorTwoColumns.py
}

createTheFile(){
	#create newfile
	> "$newfile"
	
	#echo shebang line into newfile
	case "$1" in
		.sh ) echo "#!/usr/local/bin/bash" > "$newfile" ;;
		.pl ) echo "#!/usr/local/bin/perl" > "$newfile" ;;
		.rb ) echo "#!/Users/jacobmenke/.rvm/rubies/ruby-2.3.3/bin/ruby" > "$newfile" ;;
		.py ) echo "#!/Library/Frameworks/Python.framework/Versions/3.5/bin/python3" > $newfile ;;
		#if .txt then just open the file, this is the case for plain text files
		#exit so do not call executableScriptsProcessing
		* 	) open -t "$newfile"; exit;;
	esac

	executableScriptsProcessing
	
}

#if no arguments then exit
if [[ -z "$1" ]]; then
	printf "I need an argument ...\n"
	exit 1
fi
#file name is the first argument
newfile="$1"

set -x

#check ending on file name and call createTheFile passing in argument for file ending
if [[ "$newfile" =~ .*\.sh ]]; then
	createTheFile .sh
elif [[ "$newfile" =~ .*\.pl ]]; then
	createTheFile .pl
elif [[ "$newfile" =~ .*\.rb ]]; then
	createTheFile .rb
elif [[ "$newfile" =~ .*\.py ]]; then
	createTheFile .py
elif [[ "$newfile" =~ .*\.txt ]]; then  #.txt
	createTheFile .txt
else
	#if no file ending default to text file
	#construct file with ending of .txt
	#call createTheFile with 2 arguments
	newfile="$newfile".txt
	echo "the newfile is $newfile"
	createTheFile .txt
fi

