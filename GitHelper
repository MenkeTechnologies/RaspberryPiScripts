#!/usr/local/bin/bash
#created by JAKOBMENKE --> Fri Jan 13 22:25:46 EST 2017
#

#functions

# set -x

prettyPrint(){
	printf "\E[37;44m"
	printf "$1"
	printf "\E[0m\n"
}

initializeGitDirectory(){
	#there is no .git directory
if [[ ! -d ".git" ]]; then
	prettyPrint "Do you want to initialize this directory with Git?"
	read -n1
	echo
	case "$REPLY" in
		[yY] ) git init; getRemoteDetails ;;
			*) exit
	esac
	#if user says no, then exitting
else
	#there is a .git directory but no setup for remote
	if [[ "$(git remote)" == "" ]]; then
		getRemoteDetails
	else
	#there is a .git directory and there is setup for remote so exit
		prettyPrint "Already initialized."
		exit
	fi

fi
}

#create remote Repo on github
getRemoteDetails(){
	if [[ -z "$1" ]]; then
		prettyPrint "What is the name of your Repository to create?"
		read REPO_NAME_TO_CREATE
	else
		prettyPrint "Remaking Deleted Repository."
		REPO_NAME_TO_CREATE="$1"
	fi

	curl -u "$GITHUB_ACCOUNT" https://api.github.com/user/repos -d {\"name\":\"$REPO_NAME_TO_CREATE\"}
	clear
	local ORGIN_NAME="$(git remote -v | awk '{print $1}' | tail -1 | tr -d ' ')"
	if [[ "$ORGIN_NAME" == "" ]]; then
		prettyPrint "What is your origin?"
		read ORGIN_NAME
	fi
	local URL="https://github.com/$GITHUB_ACCOUNT/$REPO_NAME_TO_CREATE"
	git remote add "$ORGIN_NAME" "$URL" 2> /dev/null
	getInitialCommit
}

getInitialCommit(){
	prettyPrint "What is your commit message?"
	read commitMessage
	commitTheDirectory "$commitMessage"
}

usage(){

	printf "\E[37;44m"
	if [[ ! -z "$1" ]]; then
		printf "$1\n"
	fi
cat <<Endofmessage
usage:
	-h	help
	-l 	pull from Repo
	-p 	<COMMIT_MESSAGE> push to Repo
	-c 	init Repo
Endofmessage
	printf "\E[0m"
}

gitPull(){
	if [[ -d ".git" && ! -z "$(git remote)" ]]; then
		local PULL_URL="$(git remote -v | awk '{print $2}' | tail -1 | tr -d ' ')"
		git pull "$PULL_URL"
	else
		usage "No Remote Repository established."
		exit
	fi

}

gitPush(){
	if [[ -z "$1" ]]; then
			usage "Need a commit message."
			exit
	fi
	if [[ -d ".git" && ! -z "$(git remote)" ]]; then
		commitTheDirectory "$1"
	else
		usage "No Remote Repository established."
		exit
	fi
}

commitTheDirectory(){
	local commitMessage="$1"
	local ORIGIN="$(git remote -v | awk '{print $1}' | tail -1 | tr -d ' ')"
	prettyPrint "Commiting to $ORIGIN with message $commitMessage"
	git add .
	git commit -m "$commitMessage"
	git push "$ORIGIN" master
	if [[ $? > 0 ]]; then
		local REPO_NAME="$(git remote -v | awk '{print $2}' | tail -1 | tr -d ' ')"
		getRemoteDetails "${REPO_NAME##*/}"
	fi
}

##########################################
###############    MAIN     ##############
##########################################

optstring=p:hcl
while getopts $optstring opt
do
  case $opt in
  	c) initializeGitDirectory;;
    l) gitPull;;
	p) gitPush "$OPTARG";;
    h) usage;;
    *) usage;;
esac
done

if [[ $OPTIND == 1 ]]; then
	if [[ -z "$1" ]]; then
		gitPush "default-commit"
	else
		gitPush "$1"
	fi
fi


# printf "\E[0m"
