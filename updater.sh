#dialog --title "MSG BOX" --infobox "Starting Updater" 40 70
#clear screen
clear
#start white text on blue background \E44:37m, -e required for escape sequences
echo -e "\E[44;37mUpdating Python Dependencies"
#pip lists outdated programs and get first column with awk
#store in outdated
outdated=`pip list --outdated | awk '{print $1}'`

#install outdated Python programs
pip install --upgrade pip &> /dev/null
for i in $outdated; do
	pip install --upgrade $i #&> /dev/null
done

echo -e "\E[44;37mUpdating Ruby Dependencies"
gem update

echo -e "\E[44;37mUpdating Homebrew Dependencies"
brew update #&> /dev/null
brew upgrade #&> /dev/null
#remote old programs occupying disk sectors
brew cleanup
brew cask cleanup

#first argument is user@host and port number configured in .ssh/config
updatePI(){
#-t to force pseudoterminal allocation for interactive programs on remote host
#pipe yes into programs that require confirmation
#semicolon to chain commands
ssh -t "$1" "yes | sudo apt-get update; yes | sudo apt-get dist-upgrade;yes | sudo apt-get autoremove; yes | sudo apt-get upgrade;"
}

arrayOfPI=(r)

#for loop through arrayOfPI, each item in array is item is .ssh/config file
for i in ${arrayOfPI[@]}; do
	updatePI $i
done

#decolorize prompt
echo -e "Done\E[0m"
clear
