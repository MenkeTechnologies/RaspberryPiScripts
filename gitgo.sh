#!/usr/local/bin/bash
#created by JAKOBMENKE --> Fri Jan 13 22:25:46 EST 2017 
printf "\E[37;44m"

#functions

initializeGitDirectory(){
	#there is no .git directory
if [[ ! -d ".git" ]]; then
	printf "Do you want to initialize this directory with Git?\n"
	read -n1
	echo
	case "$REPLY" in
		[yY] ) git init; DONE=false; getRemoteDetails ;;
			*)
	esac
	#if user says no, then exitting because DONE=true
else
	#there is a .git directory but no setup for remote
	if [[ "$(git remote)" == "" ]]; then
		getRemoteDetails
	fi
	#if user inputted just gc then done at this point
	#if user inputted a parm then keep on going
	if [[ "$1" != "" && "$PULL_URL" == "" ]]; then
		DONE=false
	else
		if [[ "$PULL_URL" != "" ]]; then	
			printf "Must have a commitMessage.\n"

		fi
	fi
fi
}

commitTheDirectory(){
	printf "Commiting to $ORIGIN with message $commitMessage\n"
	git add .
	git commit -m "$commitMessage"
	git push "$ORIGIN" master
	export ORIGIN="$ORIGIN"

}

getRemoteDetails(){
	printf "What is the name of your Repository to create?\n"
	read REPO_NAME_TO_CREATE
	curl -u 'MenkeTechnologies' https://api.github.com/user/repos -d {\"name\":\"$REPO_NAME_TO_CREATE\"}
	clear
	printf "What is your origin?\n"
	read ORGIN_NAME
	URL="https://github.com/MenkeTechnologies/$REPO_NAME_TO_CREATE"
	git remote add "$ORGIN_NAME" "$URL"
	getInitialCommit
}

getInitialCommit(){
	printf "What is your commit message?\n"
	read commitMessage
	ORIGIN="$ORGIN_NAME"
	commitTheDirectory
}

usage(){

cat <<Endofmessage
usage:
	-h	help
	-p 	pull from Repo
Endofmessage

}

gitPull(){
	PULL_URL="$(git remote -v | awk '{print $2}' | tail -1 | tr -d ' ')"
	git pull "$PULL_URL"

}

#get options
PULL_URL=""

optstring=phc
while getopts $optstring opt
do
  case $opt in
  	c) initializeGitDirectory
    p) gitPull;;
    h) usage;;
    *)
esac
done

DONE=true


if [[ $DONE == false ]]; then
	if [[ "$1" == "" ]]; then
		printf ""
	else
		commitMessage="$1"
		if [[ $2 == "" ]]; then

			if [[ $ORIGIN != "$(git remote)" ]]; then
				printf "Need a second argument for the origin name due to change of directory.\n"
				printf "your choices are \"$(git remote)\"\n"
			else
			#origin was found in env
			commitTheDirectory

			fi
		else
			#origin was not found in env so grab from positional parm 2
			ORIGIN="$2"
			commitTheDirectory
		fi

	fi
fi

printf "\E[0m"

