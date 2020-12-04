#!/bin/bash

###vars
SYS=$(systemctl status apache2 > files/apache.log)
STATUS_PATH=files/apache.log
PACKAGES_PATH=files/packages
####vars

yesno(){
 dialog --yesno "$*" 0 0
}

btnAction(){

if [ $? -eq 1 ]
then
  dialog --msgbox "Saída -> $( date "+%d/%m/%Y %H:%M" )   Usuário -> ${USER^^} \nScript -> $0" 10 30; clear; 
fi
}

menu(){
  DATA=$(date +%d/%m/%Y)
  SELECTION=$(dialog --stdout 						\
                     --title "Administração do Servidor $(hostname -s)" \
                     --radiolist "Data Local -> ${DATA}" 0 0 0 		\
                     1 'status do webserver' off			\
                     2 'visualizar a página web do webserver' on 	\
                     3 'Editar o arquivo de log' off 			\
		     4 'Sair' off					\
  		     5 'Instalar pacotes' off;				)
}


installPKG(){
	dialog --stdout \
	       --editbox ${PACKAGES_PATH} 0 0 >  ${PACKAGES_PATH}
	if [ $? -eq 0 ]
	then
	   for PACKAGE in $(cat files/packages); do yum install -y $PACKAGE >> ${PACKAGES_PATH}.log; done &
	   dialog --tailbox  ${PACKAGES_PATH}.log 0 0
	   echo > ${PACKAGES_PATH}.log
	else
	   btnAction
	fi
}


status(){
 NAME=$(dialog --stdout 			\
	       --title "STATUS: ${STATUS_PATH}" \
	       --textbox ${STATUS_PATH}  0 0	)
        clear;
}

web(){
  lynx 127.0.0.1;
}

editor(){
  dialog --stdout \
	 --editbox ${STATUS_PATH} 0 0  > files/editbox.txt

  if [ $? -eq 0 ] 
  then
     yesno "Deseja Mesmo salvar as alterações?"
    if [ $? -eq 0 ]
    then
      echo -e "##################\n Modificado em: ${DATA} \n Por: ${USER} \n###########">> files/editbox.txt
      cat ./files/editbox.txt > ${STATUS_PATH}
  else
    	btnAction;
    fi
  fi
}
