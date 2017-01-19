#show the path, PWD is environment variable in BASH
echo $PWD/"$1"
#printf using no newline and single quotes
#(to escape spaces and special characters)
#and pipe path into pbcopy
printf \'$PWD/"$1"\'| pbcopy
#alternatively, to print and pipe into pbcopy
#printf \'$PWD/"$1"\' | tee /dev/tty | pbcopy 
