#!/bin/bash
source "$PWD/func.sh"

while :; do
menu;
btnAction;
case $SELECTION in 
   1)
	status;
   ;;
   2)
	web;
   ;;

   3)	editor;
   ;;
   *)
	clear;
	exit;
  esac
clear;
done
