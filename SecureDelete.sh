#!/usr/local/bin/bash

PASSES=7         #  Number of file-shredding passes.
                 #  Increasing this slows script execution,
                 #+ especially on large target files.
BLOCKSIZE=1      #  I/O with /dev/urandom requires unit block size,
                 #+ otherwise you get weird results.
E_BADARGS=70     #  Various error exit codes.
E_NOT_FOUND=71
E_CHANGED_MIND=72


arr=(  '|' '\' '-' '/' )
revarr=( '|' '/' '-' '\')

displayProgress(){

  while [[ 1 ]]; do
    tput civis
    tput bold
    for i in {0..1}; do

      for k in "${arr[@]}"; do
        printf "$k"

        tput cub 1
        sleep 0.1
      done

    done

  done


}

startCursor(){
  tput civis
  tput bold
  displayProgress &
  progress_pid=$!
}

killCursor(){
  kill $progress_pid
  wait $progress_pid 2>/dev/null
  tput cnorm
}

if [[ -z "$1" ]]; then
  echo "Usage: `basename $0` filename"
  exit $E_BADARGS
fi

for i in "$@"; do
  file="$i"

  if [[ ! -e "$file" ]]
    then
    echo "File \"$file\" not found."
    exit $E_NOT_FOUND
  fi  

  printf "Are you sure you want to blot out \"$file\" (y/n)? "; 
  startCursor
  read -n1 answer

  case "$answer" in
    [nN]) echo;echo "Bye"
    killCursor
    exit $E_CHANGED_MIND;;
    *)    echo "Blotting out file \"$file\".";;
esac


 flength=$(ls -l "$file" | awk '{print $5}')  # Field 5 is file length.
 pass_count=1
chmod u+w "$file"   # Allow overwriting/deleting the file.


while [ "$pass_count" -le "$PASSES" ]
do
  echo "Pass #$pass_count"
  sync         # Flush buffers.
  dd if=/dev/urandom of="$file" bs=$BLOCKSIZE count=$flength
               # Fill with random bytes.
  sync         # Flush buffers again.
  dd if=/dev/zero of="$file" bs=$BLOCKSIZE count=$flength
               # Fill with zeros.
  sync         # Flush buffers yet again.
  let "pass_count += 1"
  echo
done  


rm -f "$file"    # Finally, delete scrambled and shredded file.
sync           # Flush buffers a final time.

echo "File \"$file\" blotted out and deleted."; echo


done
sleep 1
killCursor

exit 0