#!/bin/bash

###vars
SYS=$(systemctl status httpd > files/apache.log)
STATUS_PATH=files/apache.log
PACKAGES_PATH=files/packages
USUARIO_PATH=files/usuarios
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
                     1 'Status do webserver' 		off		\
                     2 'Deletar Usuarios' 		on		\
                     3 'Remover Pacotes' 	off			\
  		     4 'Instalar Pacotes' 		off		\
		     5 'Adicionar Usuários' 		off		\
		     6 'Sair' 				off;		)

}


installPKG(){
	dialog --stdout \
	       --editbox ${PACKAGES_PATH} 0 0 >  ${PACKAGES_PATH}
	if [ $? -eq 0 ]
	then
	   for PACKAGE in $(cat files/packages); do dnf install -y $PACKAGE >> ${PACKAGES_PATH}.log; done &
	   dialog --tailbox  ${PACKAGES_PATH}.log 30 100
	   echo > ${PACKAGES_PATH}.log
	else
	   btnAction
	fi
}


addUsers(){
	dialog --stdout \
	       --editbox ${USUARIO_PATH} 0 0 > ${USUARIO_PATH}
	if [ $? -eq 0 ]
	then
	   for USUARIO in $(cat files/usuarios)
	   do adduser $USUARIO; echo "Usuario -> $USUARIO adicionado " >> ${USUARIO_PATH}.log; done 
	   echo > ${USUARIO_PATH}
	   dialog --tailbox ${USUARIO_PATH}.log 0 0
	   echo > ${USUARIO_PATH}.log

	else
	   btnAction
	fi

}

delUsers(){
        dialog --stdout \
               --editbox ${USUARIO_PATH} 0 0 > ${USUARIO_PATH}
        if [ $? -eq 0 ]
        then
           for USUARIO in $(cat files/usuarios)
           do userdel -r $USUARIO; echo "Usuario -> $USUARIO removido " >> ${USUARIO_PATH}.log; done 
           echo > ${USUARIO_PATH}
           dialog --tailbox ${USUARIO_PATH}.log 0 0
           echo > ${USUARIO_PATH}.log

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





removePKG(){
dialog --stdout \
               --editbox ${PACKAGES_PATH} 0 0 >  ${PACKAGES_PATH}
        if [ $? -eq 0 ]
        then
           for PACKAGE in $(cat files/packages); do dnf remove -y $PACKAGE >> ${PACKAGES_PATH}.log; done &
           dialog --tailbox  ${PACKAGES_PATH}.log 30 100
           echo > ${PACKAGES_PATH}.log
        else
           btnAction
        fi



}
