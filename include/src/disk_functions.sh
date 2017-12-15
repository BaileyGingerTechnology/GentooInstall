#!/bin/bash
# Author  : Bailey Kasin
# Date    : 12/14/2017
# Purpose : Function used for disk setup

function chose_disk {

	echo "$@"
	select option; do # in "$@" is the default
		if [ "$REPLY" -eq "$#" ]; then
			echo "Exiting..."
			break;
		elif [ 1 -le "$REPLY" ] && [ "$REPLY" -le $(($#-1)) ]; then
			echo "You selected $option which is option $REPLY"
			break;
		else
			echo "Incorrect Input: Select a number 1-$#"
		fi
	done
}