#escape sequences
BLUE='\E[37;44m'
RESET='\E[0m'

#loop through stdin and add escape sequences at head and tail of each line
while read input; do
	printf "${BLUE}$input${RESET}\n"
done
