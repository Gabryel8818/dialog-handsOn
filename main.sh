#!/bin/bash
source "$PWD/func.sh"

while :; do
menu;
btnAction;
case $SELECTION in 
   1)
	status
   ;;
   2)
	delUsers;
   ;;

   3)	removePKG;
   ;;

   4)	installPKG;
   ;;
   5) 	addUsers;
   ;;
   *)
	clear;
	exit;
  esac
clear;
done
