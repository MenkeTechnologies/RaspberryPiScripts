if [[ "$#" == 0 ]]; then
    echo "Need one argument."
    exit
fi

messageToSpeak=""
for i in "$*"; do
	messageToSpeak+="$i"
done

#first argument will be spoken by all voices
#create list of voices into awk and get first column and sort lexicographically
#loop through each voice in this list
for i in `say -v ? | awk '{print $1}' | sort`; do
#display who is speaking
echo "The voice is $i"
#the say command using each voice and saying the first argument to the script
say -v $i "$messageToSpeak"
done


