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

   3)	editor;
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
